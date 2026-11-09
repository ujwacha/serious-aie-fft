#pragma once

#include <adf.h>
#include <aie_api/aie.hpp>
#include <aie_api/fft.hpp>

using namespace adf;

class my_kernel {
public:
  typedef cint16 TT_DATA;


private:


public:
  // Constructor:
  my_kernel();



  // Run:
  void run(input_buffer<TT_DATA> & in,output_buffer<TT_DATA> & out);

  static void registerKernelClass( void )
  {
    REGISTER_FUNCTION( my_kernel::run );
  }
};
