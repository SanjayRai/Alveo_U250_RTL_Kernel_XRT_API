/**********
Copyright (c) 2018, Xilinx, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors
may be used to endorse or promote products derived from this software
without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**********/
#include "xcl2.hpp"
#include "xclhal2.h"
#include "unistd.h"
#include <vector>
#include <chrono>

//#define MAX_BUFFER_SIZE 64*1024*1024
//#define MAX_BUFFER_SIZE 8*1024*1024
#define MAX_BUFFER_SIZE 1024
//#define MAX_BUFFER_SIZE 512
//#define MAX_BUFFER_SIZE 256
//#define MAX_BUFFER_SIZE 128
//#define MAX_BUFFER_SIZE 64
#define KERNEL_BRAM_SZ 8192
#define KERNEL_0_BRAM_OFFSET 0x1808000
#define NUM_BUFFERS 16 

using namespace std;

void SRAI_dbg_wait (string dbg_string) {
    string Srai_dbg_wait;
    cout << "Dbg Pause  :  " << dbg_string << "  :  Enterany charater (followed by Enter Key) to proceed : ";
    cin >> Srai_dbg_wait;
}

int main(int argc, char** argv)
{
    if (argc != 2) {
        cout << "Usage: " << argv[0] << " <XCLBIN File>" << endl;
        return EXIT_FAILURE;
    }

    typedef int data_type;

    string binaryFile = argv[1];
    xclDeviceHandle xcl_dev;
    cl_int err;
    unsigned fileBufSize;
    size_t MAX_vector_size_bytes = sizeof(data_type)*MAX_BUFFER_SIZE;
    uint32_t pipeline_num[NUM_BUFFERS];
    fill_n(pipeline_num, NUM_BUFFERS, 0x00000001);
    //Allocate Memory in Host Memory
    uint32_t vector_size[NUM_BUFFERS];
    fill_n(vector_size, NUM_BUFFERS, MAX_BUFFER_SIZE);

    //Allocate Memory in Host Memory
    vector< vector<data_type,aligned_allocator<data_type>> > source_input1    (NUM_BUFFERS, vector<data_type,aligned_allocator<data_type>>(MAX_BUFFER_SIZE));
    vector< vector<data_type,aligned_allocator<data_type>> > source_input2    (NUM_BUFFERS, vector<data_type,aligned_allocator<data_type>>(MAX_BUFFER_SIZE));
    vector< vector<data_type,aligned_allocator<data_type>> > source_hw_results(NUM_BUFFERS, vector<data_type,aligned_allocator<data_type>>(MAX_BUFFER_SIZE));
    vector< vector<data_type,aligned_allocator<data_type>> > source_hw_results_D(NUM_BUFFERS, vector<data_type,aligned_allocator<data_type>>(MAX_BUFFER_SIZE));
    vector< vector<data_type,aligned_allocator<data_type>> > source_sw_results(NUM_BUFFERS, vector<data_type,aligned_allocator<data_type>>(MAX_BUFFER_SIZE));


    //double high_res_elapsed_time_HW[NUM_BUFFERS];
    //chrono::high_resolution_clock::time_point start_t;
    //chrono::high_resolution_clock::time_point stop_t;
    //chrono::duration<double> elapsed_hi_res;


    xcl_dev = xclOpen(0, "Srai_dev.log", XCL_INFO);

//OPENCL HOST CODE AREA START
    //Create Program and Kernel
    vector<cl::Device> devices = xcl::get_xil_devices();
    cl::Device device = devices[0];

    OCL_CHECK(err, cl::Context context(device, NULL, NULL, NULL, &err));
    OCL_CHECK(err, cl::CommandQueue q(context, device, CL_QUEUE_PROFILING_ENABLE, &err));
    //OCL_CHECK(err, cl::CommandQueue q(context, device, CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE|CL_QUEUE_PROFILING_ENABLE, &err));
    //OCL_CHECK(err, cl::CommandQueue q(context, device, CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE, &err));
    string device_name = device.getInfo<CL_DEVICE_NAME>(); 

    char* fileBuf = xcl::read_binary_file(binaryFile, fileBufSize);
    cl::Program::Binaries bins{{fileBuf, fileBufSize}};
    devices.resize(1);
    OCL_CHECK(err, cl::Program program(context, devices, bins, NULL, &err));
    OCL_CHECK(err, cl::Kernel krnl_vadd(program,"krnl_vadd_2clk_rtl", &err));

    // ********************************************************
    // __SRAI test BRAM on AXI_lite interface using HAL2 driver
    // ********************************************************
    cout << "Starting Kernel Parameter Axi_lite  8K BRAM Test " << endl;
    int *p_KERNEL_BRAM = new int[KERNEL_BRAM_SZ];
    int *p_KERNEL_BRAM_read = new int[KERNEL_BRAM_SZ];
    for (int i = 0 ; i < KERNEL_BRAM_SZ; i++) {
       p_KERNEL_BRAM[i] = 0x5A690000 + i;
    }
    xclWrite(xcl_dev, XCL_ADDR_KERNEL_CTRL,KERNEL_0_BRAM_OFFSET, p_KERNEL_BRAM, sizeof(data_type)*KERNEL_BRAM_SZ); 

    xclRead(xcl_dev, XCL_ADDR_KERNEL_CTRL,KERNEL_0_BRAM_OFFSET, p_KERNEL_BRAM_read, sizeof(data_type)*KERNEL_BRAM_SZ); 
    int err_count = 0;
    for (int i = 0 ; i < KERNEL_BRAM_SZ; i++) {
       if (p_KERNEL_BRAM_read[i] != p_KERNEL_BRAM[i]) {
           err_count++;
       }
       p_KERNEL_BRAM[i] = 0x5A690000 + i;
    }

    cout << "Kernel Parameter Axi_lite  8K BRAM Test Error count = " << err_count << endl;

    delete[] p_KERNEL_BRAM;
    delete[] p_KERNEL_BRAM_read;

    // ********************************************************
    // __SRAI test BRAM on AXI_lite interface using HAL2 driver
    // ********************************************************
    xclClose(xcl_dev);


    // "*************************************************\n";
    //vector_size[2] = (uint32_t)(MAX_BUFFER_SIZE/2);
    //vector_size[4] = (uint32_t)(MAX_BUFFER_SIZE/4);
    // Create the test data and Software Result 
    for(uint32_t j = 0 ; j < NUM_BUFFERS ; j++){
        for(uint32_t i = 0 ; i < vector_size[j] ; i++){
            source_input1[j][i] = (data_type)((3*i)+j+0x3300);
            source_input2[j][i] = (data_type)(((5*i)+j + 0x6600) | ((j+1) << 28));
            source_sw_results[j][i] = (data_type)(source_input1[j][i] + source_input2[j][i]);
            source_hw_results[j][i] = (data_type)0;
            source_hw_results_D[j][i] = (data_type)0;
        }
    }


    //Allocate Buffers in Global Memory (on FPGA)
    std::vector<cl::Buffer> buffer_r1;
    std::vector<cl::Buffer> buffer_r2;
    std::vector<cl::Buffer> buffer_w;
    std::vector<cl::Buffer> buffer_d;

    for (size_t i = 0; i < NUM_BUFFERS; ++i) {
        if (i%2)
            pipeline_num[i] = 0x00000001;
        else
            pipeline_num[i] = 0x00000002;

        OCL_CHECK(err, cl::Buffer ocl_buffer_r1( context,CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY, MAX_vector_size_bytes, source_input1[i].data(), &err));
        buffer_r1.push_back(ocl_buffer_r1);

        OCL_CHECK(err, cl::Buffer ocl_buffer_r2( context,CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY, MAX_vector_size_bytes, source_input2[i].data(), &err));
        buffer_r2.push_back(ocl_buffer_r2);

        OCL_CHECK(err, cl::Buffer ocl_buffer_w( context,CL_MEM_USE_HOST_PTR | CL_MEM_WRITE_ONLY, MAX_vector_size_bytes, source_hw_results[i].data(), &err));
        buffer_w.push_back(ocl_buffer_w);

        OCL_CHECK(err, cl::Buffer ocl_buffer_d( context,CL_MEM_USE_HOST_PTR | CL_MEM_WRITE_ONLY, MAX_vector_size_bytes, source_hw_results_D[i].data(), &err));
        buffer_d.push_back(ocl_buffer_d);

    }

    SRAI_dbg_wait ("__SRAI Start_kernel");

    std::vector<cl::Event> ooo_req;
    for(uint32_t i = 0 ; i < NUM_BUFFERS ; i++){
        // Set the pipeline[31] to 1 for the final buffer to mux in the wr_done as opposed to immedeate done.
        OCL_CHECK(err, err = krnl_vadd.setArg(0,buffer_r1[i]));
        OCL_CHECK(err, err = krnl_vadd.setArg(1,buffer_r2[i]));
        OCL_CHECK(err, err = krnl_vadd.setArg(2,buffer_w[i]));
        OCL_CHECK(err, err = krnl_vadd.setArg(3,MAX_BUFFER_SIZE));
        OCL_CHECK(err, err = krnl_vadd.setArg(4,pipeline_num[i])); //Routes the inpouts to a pipline specified by pipeline_num
        OCL_CHECK(err, err = krnl_vadd.setArg(5,buffer_d[i])); //Routes the inpouts to a pipline specified by pipeline_num
        cl::Event req;
        OCL_CHECK(err, err = q.enqueueTask(krnl_vadd,NULL,&req));
        ooo_req.push_back(req);
    }

    for(uint32_t i = 0 ; i < NUM_BUFFERS ; i++){
        OCL_CHECK(err, err = q.enqueueMigrateMemObjects({buffer_r1[i]},0/* 0 means from host*/));
        OCL_CHECK(err, err = q.enqueueMigrateMemObjects({buffer_r2[i]},0/* 0 means from host*/));
        OCL_CHECK(err, err = q.enqueueMigrateMemObjects({buffer_w[i]},CL_MIGRATE_MEM_OBJECT_HOST,&ooo_req));
        OCL_CHECK(err, err = q.enqueueMigrateMemObjects({buffer_d[i]},CL_MIGRATE_MEM_OBJECT_HOST,&ooo_req));
    }

    OCL_CHECK(err, err = q.finish());



    // Compare the results of the Device to the simulation
    int match = 0;
    for(uint32_t j = 0 ; j < NUM_BUFFERS ; j++){
        for (uint32_t i = 0 ; i < vector_size[j] ; i++){
            if(pipeline_num[j] & 0x00000001){
                if (source_hw_results[j][i] != source_sw_results[j][i]){
                    cout << "Error: Result mismatch" << endl;
                    cout << "i = " << i << " Software result = 0x" << hex << source_sw_results[j][i]
                        << " Device result = 0x" << source_hw_results[j][i] << endl;
                    match = 1;
                    break;
                }
            } else {
                if (source_hw_results_D[j][i] != source_sw_results[j][i]){
                    cout << "Error: Result mismatch" << endl;
                    cout << "i = " << i << " Software result = 0x" << hex << source_sw_results[j][i]
                        << " Device result = 0x" << source_hw_results[j][i] << endl;
                    match = 1;
                    break;
                }
            }
        }
        cout << "TEST Buffer " << j  << (match ? " FAILED" : " PASSED") << endl; 
    }


    cout << "TEST " << (match ? "FAILED" : "PASSED") << endl; 
    cout << "*************************************************\n";
    




    delete[] fileBuf;
}
