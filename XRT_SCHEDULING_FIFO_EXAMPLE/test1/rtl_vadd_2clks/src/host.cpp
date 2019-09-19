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

//#define MAX_BUFFER_SIZE 1024*1024*1024ULL
//#define MAX_BUFFER_SIZE 64*1024ULL*1024ULL
//#define MAX_BUFFER_SIZE 512
//#define MAX_BUFFER_SIZE 256
//#define MAX_BUFFER_SIZE 128
#define MAX_BUFFER_SIZE 64
#define KERNEL_BRAM_SZ 32
#define KERNEL_0_CONTROL_REG_OFFSET  0x1800000
#define KERNEL_0_BRAM_OFFSET         0x1808000
#define KERNEL_0_CMD_FIFO_STALL      0x180C000
#define KERNEL_0_CMD_IN_FLIGHT       0x180D000
#define NUM_BUFFERS                  4
#define TIMEOUT_MAX                  100000000
//
//
//Addresses below are KERNEL_0_CONTROL_REG_OFFSET + the following Offsets
//------------------------Address Info-------------------
// 0x00 : Control signals
//        bit 0  - ap_start (Read/Write/COH)
//        bit 1  - ap_done (Read/COR)
//        bit 2  - ap_idle (Read)
//        bit 3  - ap_ready (Read)
//        bit 4  - ap_continue (Read/Write/SC)
//        bit 7  - auto_restart (Read/Write)
//        others - reserved
// 0x04 : Global Interrupt Enable Register
//        bit 0  - Global Interrupt Enable (Read/Write)
//        others - reserved
// 0x08 : IP Interrupt Enable Register (Read/Write)
//        bit 0  - Channel 0 (ap_done)
//        bit 1  - Channel 1 (ap_ready)
//        others - reserved
// 0x0c : IP Interrupt Status Register (Read/TOW)
//        bit 0  - Channel 0 (ap_done)
//        bit 1  - Channel 1 (ap_ready)
//        others - reserved
// 0x10 : Data signal of a
//        bit 31~0 - a[31:0] (Read/Write)
// 0x14 : Data signal of a
//        bit 31~0 - a[63:32] (Read/Write)
// 0x18 : reserved
// 0x1c : Data signal of b
//        bit 31~0 - b[31:0] (Read/Write)
// 0x20 : Data signal of b
//        bit 31~0 - b[63:32] (Read/Write)
// 0x24 : reserved
// 0x28 : Data signal of c
//        bit 31~0 - c[31:0] (Read/Write)
// 0x2c : Data signal of c
//        bit 31~0 - c[63:32] (Read/Write)
// 0x30 : reserved
// 0x34 : Data signal of length_r
//        bit 31~0 - length_r[31:0] (Read/Write)
// 0x38 : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

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
    uint32_t vector_size[NUM_BUFFERS];
    fill_n(vector_size, NUM_BUFFERS, MAX_BUFFER_SIZE);

    //Allocate Memory in Host Memory
    vector< vector<data_type,aligned_allocator<data_type>> > source_input1    (NUM_BUFFERS, vector<data_type,aligned_allocator<data_type>>(MAX_BUFFER_SIZE));
    vector< vector<data_type,aligned_allocator<data_type>> > source_input2    (NUM_BUFFERS, vector<data_type,aligned_allocator<data_type>>(MAX_BUFFER_SIZE));
    vector< vector<data_type,aligned_allocator<data_type>> > source_hw_results(NUM_BUFFERS, vector<data_type,aligned_allocator<data_type>>(MAX_BUFFER_SIZE));
    vector< vector<data_type,aligned_allocator<data_type>> > source_sw_results(NUM_BUFFERS, vector<data_type,aligned_allocator<data_type>>(MAX_BUFFER_SIZE));

    xclBOProperties source_input1_BO[NUM_BUFFERS];
    xclBOProperties source_input2_BO[NUM_BUFFERS];
    xclBOProperties source_hw_results_BO[NUM_BUFFERS];


    //double high_res_elapsed_time;
    double high_res_elapsed_time_HW[NUM_BUFFERS];
    //double high_res_elapsed_time_SW = 0.0f;
    chrono::high_resolution_clock::time_point start_t;
    chrono::high_resolution_clock::time_point stop_t;
    chrono::duration<double> elapsed_hi_res;
    xclDeviceInfo2 srai_dev;
    uint32_t KERNEL_CONTROL_REG = 0x0;

    uint64_t timeout_v = 0;


    xcl_dev = xclOpen(0, "Srai_dev.log", XCL_INFO);

    vector_size[2] = (uint32_t)(MAX_BUFFER_SIZE/2);
    //vector_size[4] = (uint32_t)(MAX_BUFFER_SIZE/4);
    // Create the test data and Software Result 
    for(uint32_t j = 0 ; j < NUM_BUFFERS ; j++){
        for(uint32_t i = 0 ; i < vector_size[j] ; i++){
            source_input1[j][i] = (data_type)((1*i)+0x6600);
            source_input2[j][i] = (data_type)(((3*j) + 0x9900) | ((j+1) << 28));
            source_sw_results[j][i] = (data_type)(source_input1[j][i] + source_input2[j][i]);
            source_hw_results[j][i] = (data_type)0;
        }
    }

//OPENCL HOST CODE AREA START
    //Create Program and Kernel
    vector<cl::Device> devices = xcl::get_xil_devices();
    cl::Device device = devices[0];

    OCL_CHECK(err, cl::Context context(device, NULL, NULL, NULL, &err));
    OCL_CHECK(err, cl::CommandQueue q(context, device, CL_QUEUE_PROFILING_ENABLE, &err));
    string device_name = device.getInfo<CL_DEVICE_NAME>(); 
    xclGetDeviceInfo2(xcl_dev, &srai_dev);
    cout << "Device name = " << srai_dev.mName << endl;
    cout << "Device onChip Temp  = " << srai_dev.mOnChipTemp << endl;
    cout << "Device Fan Temp  = " << srai_dev.mFanTemp << endl;
    cout << "Device PCIe LinkWidth= " << srai_dev.mPCIeLinkWidth << endl;
    cout << "Device PCIe LinkSpeed= " << srai_dev.mPCIeLinkSpeed << endl;


    char* fileBuf = xcl::read_binary_file(binaryFile, fileBufSize);
    cl::Program::Binaries bins{{fileBuf, fileBufSize}};
    devices.resize(1);
    OCL_CHECK(err, cl::Program program(context, devices, bins, NULL, &err));

    uint32_t KERNEL_CMD_FIFO_STALL_VAL = 0x0;
    xclWrite(xcl_dev, XCL_ADDR_KERNEL_CTRL, KERNEL_0_CMD_FIFO_STALL, &KERNEL_CMD_FIFO_STALL_VAL, sizeof(uint32_t)); 


    unsigned int srai_bo_src1[NUM_BUFFERS];
    unsigned int srai_bo_src2[NUM_BUFFERS];
    unsigned int srai_bo_hw_results[NUM_BUFFERS];
    for (uint32_t i = 0; i < NUM_BUFFERS ; i++) {
        srai_bo_src1[i] = xclAllocBO(xcl_dev, sizeof(data_type)*vector_size[i], XCL_BO_SHARED_PHYSICAL, 0);
        xclGetBOProperties(xcl_dev, srai_bo_src1[i], &source_input1_BO[i]);
        cout << "Dev Address for source_input1 = 0x" << hex << source_input1_BO[i].paddr << endl;
        cout << "Dev Size for source_input1 = " << dec << source_input1_BO[i].size << endl;
        cout << "Dev Handle for source_input1 = " << dec << source_input1_BO[i].handle << endl;
        xclWriteBO(xcl_dev, srai_bo_src1[i], source_input1[i].data(), sizeof(data_type)*vector_size[i], 0);
        xclSyncBO(xcl_dev, srai_bo_src1[i], XCL_BO_SYNC_BO_TO_DEVICE, sizeof(data_type)*vector_size[i], 0);

        srai_bo_src2[i] = xclAllocBO(xcl_dev, sizeof(data_type)*vector_size[i], XCL_BO_SHARED_PHYSICAL, 0);
        xclGetBOProperties(xcl_dev, srai_bo_src2[i], &source_input2_BO[i]);
        cout << "Dev Address for source_input2 = 0x" << hex << source_input2_BO[i].paddr << endl;
        cout << "Dev Size for source_input2 = " << dec << source_input2_BO[i].size << endl;
        cout << "Dev Handle for source_input2 = " << dec << source_input2_BO[i].handle << endl;
        xclWriteBO(xcl_dev, srai_bo_src2[i], source_input2[i].data(), sizeof(data_type)*vector_size[i], 0);
        xclSyncBO(xcl_dev, srai_bo_src2[i], XCL_BO_SYNC_BO_TO_DEVICE, sizeof(data_type)*vector_size[i], 0);

        srai_bo_hw_results[i] = xclAllocBO(xcl_dev, sizeof(data_type)*vector_size[i], XCL_BO_SHARED_PHYSICAL, 0);
        xclGetBOProperties(xcl_dev, srai_bo_hw_results[i], &source_hw_results_BO[i]);
        cout << "Dev Address for source_hw_results = 0x" << hex << source_hw_results_BO[i].paddr << endl;
        cout << "Dev Size for source_hw_results = " << dec << source_hw_results_BO[i].size << endl;
        cout << "Dev Handle for source_hw_results = " << dec << source_hw_results_BO[i].handle << endl;
        xclWriteBO(xcl_dev, srai_bo_hw_results[i], source_hw_results[i].data(), sizeof(data_type)*vector_size[i], 0);
        xclSyncBO(xcl_dev, srai_bo_hw_results[i], XCL_BO_SYNC_BO_TO_DEVICE, sizeof(data_type)*vector_size[i], 0);
    }

    KERNEL_CMD_FIFO_STALL_VAL = 0x1;
    xclWrite(xcl_dev, XCL_ADDR_KERNEL_CTRL, KERNEL_0_CMD_FIFO_STALL, &KERNEL_CMD_FIFO_STALL_VAL, sizeof(uint32_t)); 
    KERNEL_CONTROL_REG = (uint32_t)(0x00000000);
    xclWrite(xcl_dev, XCL_ADDR_KERNEL_CTRL, (KERNEL_0_CONTROL_REG_OFFSET + 0x10), &KERNEL_CONTROL_REG, sizeof(uint32_t)); 

    uint32_t num_cmds_in_flight = 0; 
    uint32_t prev_cmd_in_flight = 0; 
    for (uint32_t i = 0; i < NUM_BUFFERS ; i++) {

        //SRAI_dbg_wait ("SRAI_ DBG .. ILA Trig");

        KERNEL_CONTROL_REG = (uint32_t)(0x00000000FFFFFFFF & source_input1_BO[i].paddr);
        xclWrite(xcl_dev, XCL_ADDR_KERNEL_CTRL, (KERNEL_0_CONTROL_REG_OFFSET + 0x10), &KERNEL_CONTROL_REG, sizeof(uint32_t)); 
        KERNEL_CONTROL_REG = (uint32_t)((0xFFFFFFFF00000000 & source_input1_BO[i].paddr) >> 32); 
        xclWrite(xcl_dev, XCL_ADDR_KERNEL_CTRL, (KERNEL_0_CONTROL_REG_OFFSET + 0x14), &KERNEL_CONTROL_REG, sizeof(uint32_t)); 

        KERNEL_CONTROL_REG = (uint32_t)(0x00000000FFFFFFFF & source_input2_BO[i].paddr);
        xclWrite(xcl_dev, XCL_ADDR_KERNEL_CTRL, (KERNEL_0_CONTROL_REG_OFFSET + 0x1C), &KERNEL_CONTROL_REG, sizeof(uint32_t)); 
        KERNEL_CONTROL_REG = (uint32_t)((0xFFFFFFFF00000000 & source_input2_BO[i].paddr) >> 32); 
        xclWrite(xcl_dev, XCL_ADDR_KERNEL_CTRL, (KERNEL_0_CONTROL_REG_OFFSET + 0x20), &KERNEL_CONTROL_REG, sizeof(uint32_t)); 

        KERNEL_CONTROL_REG = (uint32_t)(0x00000000FFFFFFFF & source_hw_results_BO[i].paddr);
        xclWrite(xcl_dev, XCL_ADDR_KERNEL_CTRL, (KERNEL_0_CONTROL_REG_OFFSET + 0x28), &KERNEL_CONTROL_REG, sizeof(uint32_t)); 
        KERNEL_CONTROL_REG = (uint32_t)((0xFFFFFFFF00000000 & source_hw_results_BO[i].paddr) >> 32); 
        xclWrite(xcl_dev, XCL_ADDR_KERNEL_CTRL, (KERNEL_0_CONTROL_REG_OFFSET + 0x2C), &KERNEL_CONTROL_REG, sizeof(uint32_t)); 

        KERNEL_CONTROL_REG = (uint32_t)(vector_size[i]);
        xclWrite(xcl_dev, XCL_ADDR_KERNEL_CTRL, (KERNEL_0_CONTROL_REG_OFFSET + 0x34), &KERNEL_CONTROL_REG, sizeof(uint32_t)); 

        KERNEL_CONTROL_REG = (uint32_t)(0x1); // Cleared in HW
        xclWrite(xcl_dev, XCL_ADDR_KERNEL_CTRL, (KERNEL_0_CONTROL_REG_OFFSET + 0x00), &KERNEL_CONTROL_REG, sizeof(uint32_t)); 

        num_cmds_in_flight += 8; 
    }
    //
    cout << "Total NUmber of Kernel parameters enqued  :  " << num_cmds_in_flight << endl; 
    uint32_t srai_dbg_v;
    xclRead(xcl_dev, XCL_ADDR_KERNEL_CTRL, KERNEL_0_CMD_IN_FLIGHT, &srai_dbg_v, sizeof(uint32_t)); 
    cout << "Total NUmber of Kernel parameters enqued readback   :  " << srai_dbg_v << endl; 
    SRAI_dbg_wait ("SRAI_ DBG .. ILA Trig");
   // Wait for all commands enqueued to finish - THis is not really required to since completions can be pulled back to host memory as they complete
   timeout_v = 0;
   xclRead(xcl_dev, XCL_ADDR_KERNEL_CTRL, KERNEL_0_CMD_IN_FLIGHT, &num_cmds_in_flight, sizeof(uint32_t)); 
   cout << "in_Flight  NUmber of Kernel parameters enqued  :  " << num_cmds_in_flight << endl; 
    prev_cmd_in_flight = num_cmds_in_flight;

    KERNEL_CMD_FIFO_STALL_VAL = 0x0;
    xclWrite(xcl_dev, XCL_ADDR_KERNEL_CTRL, KERNEL_0_CMD_FIFO_STALL, &KERNEL_CMD_FIFO_STALL_VAL, sizeof(uint32_t)); 

    // //********************************************************************************
    // Check execution cmd FIFO status
    // //********************************************************************************
    start_t = chrono::high_resolution_clock::now();
    uint32_t ker_num = 0;
    while (num_cmds_in_flight != 0) {
        if ( (prev_cmd_in_flight-8) == num_cmds_in_flight) {
            cout << " __SRAI DBG exec : " << ker_num <<  " Prev num commands : " << prev_cmd_in_flight << " Num commands in Flight : " << num_cmds_in_flight << "  Timout_val = " << timeout_v  << endl;
            high_res_elapsed_time_HW[ker_num] = 0.0f;
            stop_t = chrono::high_resolution_clock::now();
            elapsed_hi_res = stop_t - start_t ;
            start_t = chrono::high_resolution_clock::now();
            high_res_elapsed_time_HW[ker_num] = elapsed_hi_res.count();
            ker_num++;
            prev_cmd_in_flight = num_cmds_in_flight;
        }
        xclRead(xcl_dev, XCL_ADDR_KERNEL_CTRL, KERNEL_0_CMD_IN_FLIGHT, &num_cmds_in_flight, sizeof(uint32_t)); 
        if (timeout_v > TIMEOUT_MAX) {
            cout << " Timed out waiting for CMD FIFO to Drain \n";
            break;
        } else {
            timeout_v++;
        }
    }
    stop_t = chrono::high_resolution_clock::now();
    elapsed_hi_res = stop_t - start_t ;
    high_res_elapsed_time_HW[ker_num] = elapsed_hi_res.count();
    // //********************************************************************************
    // //********************************************************************************

    timeout_v = 0;
    xclRead(xcl_dev, XCL_ADDR_KERNEL_CTRL,KERNEL_0_CONTROL_REG_OFFSET, &KERNEL_CONTROL_REG, sizeof(uint32_t)); 
    while ((KERNEL_CONTROL_REG & 0x00000002) != 0x2) {
        xclRead(xcl_dev, XCL_ADDR_KERNEL_CTRL,KERNEL_0_CONTROL_REG_OFFSET, &KERNEL_CONTROL_REG, sizeof(uint32_t)); 
        if (timeout_v > TIMEOUT_MAX) {
            cout << " Timed out waiting for CMD FIFO to Drain \n";
            break;
        } else {
            timeout_v++;
        }
    }
    cout << " Wait for final done loop count = " << timeout_v << endl;


    for (int i = 0; i < NUM_BUFFERS ; i++) {
        cout << "Execution time between sucessive  Kernel invocation  : " << i << " = " <<  high_res_elapsed_time_HW[i]  << endl;
        xclSyncBO(xcl_dev, srai_bo_hw_results[i], XCL_BO_SYNC_BO_FROM_DEVICE, sizeof(data_type)*vector_size[i], 0);
        xclReadBO(xcl_dev, srai_bo_hw_results[i], source_hw_results[i].data(), sizeof(data_type)*vector_size[i],0);
    }


    // ********************************************************
    // __SRAI test BRAM on AXI_lite interface using HAL2 driver
    // ********************************************************
    cout << "Starting Kernel Parameter Axi_lite  8K BRAM Test " << endl;
    int *p_KERNEL_BRAM = new int[KERNEL_BRAM_SZ];
    int *p_KERNEL_BRAM_read = new int[KERNEL_BRAM_SZ];
    for (int i = 0 ; i < KERNEL_BRAM_SZ; i++) {
       p_KERNEL_BRAM[i] = 0x5A690000 + i;
    }
    xclWrite(xcl_dev, XCL_ADDR_KERNEL_CTRL,KERNEL_0_BRAM_OFFSET, p_KERNEL_BRAM, sizeof(int)*KERNEL_BRAM_SZ); 

    xclRead(xcl_dev, XCL_ADDR_KERNEL_CTRL,KERNEL_0_BRAM_OFFSET, p_KERNEL_BRAM_read, sizeof(int)*KERNEL_BRAM_SZ); 
    int err_count = 0;
    for (int i = 0 ; i < KERNEL_BRAM_SZ; i++) {
       if (p_KERNEL_BRAM_read[i] != p_KERNEL_BRAM[i]) {
           err_count++;
       }
       p_KERNEL_BRAM[i] = 0x5A690000 + i;
    }

    cout << "Kernel Parameter Axi_lite  8K BRAM Test Error count = " << err_count << endl;

    // ********************************************************
    // __SRAI test BRAM on AXI_lite interface using HAL2 driver
    // ********************************************************

// __SRAI     //Copy input data to device global memory
// __SRAI     OCL_CHECK(err, err = q.enqueueMigrateMemObjects({buffer_r1, buffer_r2},0/* 0 means from host*/));
// __SRAI 
// __SRAI 
// __SRAI     //Launch the Kernel
// __SRAI     start_t = chrono::high_resolution_clock::now();
// __SRAI     OCL_CHECK(err, err = q.enqueueTask(krnl_vadd));
// __SRAI     stop_t = chrono::high_resolution_clock::now();
// __SRAI 
// __SRAI     usleep(1000000);
// __SRAI 
// __SRAI     //Copy Result from Device Global Memory to Host Local Memory
// __SRAI     OCL_CHECK(err, err = q.enqueueMigrateMemObjects({buffer_w},CL_MIGRATE_MEM_OBJECT_HOST));

    OCL_CHECK(err, err = q.finish());
    delete[] p_KERNEL_BRAM;
    delete[] p_KERNEL_BRAM_read;

    for (int i = 0; i < NUM_BUFFERS ; i++) {
        xclFreeBO(xcl_dev, srai_bo_src1[i]);
        xclFreeBO(xcl_dev, srai_bo_src2[i]);
        xclFreeBO(xcl_dev, srai_bo_hw_results[i]);
    }

    xclClose(xcl_dev);


// __SRAI    elapsed_hi_res = stop_t - start_t ;
// __SRAI    high_res_elapsed_time = elapsed_hi_res.count();
// __SRAI    high_res_elapsed_time_HW = high_res_elapsed_time;
// __SRAI    cout << "Kernel Execution time =  " <<  high_res_elapsed_time_HW << "s\n";
// __SRAI    cout << "Kernel THroughput =  " << (DATA_SIZE/high_res_elapsed_time_HW) << " Bytes/s\n";

//OPENCL HOST CODE AREA END
    
    // Compare the results of the Device to the simulation
    int match = 0;
    for(uint32_t j = 0 ; j < NUM_BUFFERS ; j++){
        for (uint32_t i = 0 ; i < vector_size[j] ; i++){
            if (source_hw_results[j][i] != source_sw_results[j][i]){
                cout << "Error: Result mismatch" << endl;
                cout << "i = " << i << " Software result = 0x" << hex << source_sw_results[j][i]
                    << " Device result = 0x" << source_hw_results[j][i] << endl;
                match = 1;
                //break;
            }
        }
    }


    delete[] fileBuf;

    cout << "TEST " << (match ? "FAILED" : "PASSED") << endl; 
    return (match ? EXIT_FAILURE :  EXIT_SUCCESS);
}
