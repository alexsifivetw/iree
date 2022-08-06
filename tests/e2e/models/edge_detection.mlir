// RUN: iree-run-mlir --iree-input-type=mhlo --iree-hal-target-backends=vmvx --function-input="1x128x128x1xf32" %s | FileCheck %s
// RUN: iree-run-mlir --iree-input-type=mhlo --iree-hal-target-backends=llvm-cpu --function-input="1x128x128x1xf32" %s | FileCheck %s
// RUN: [[ $IREE_VULKAN_DISABLE == 1 ]] || (iree-run-mlir --iree-input-type=mhlo --iree-hal-target-backends=vulkan-spirv --function-input="1x128x128x1xf32" %s | FileCheck %s)

// Image edge detection module generated by.
// https://github.com/iree-org/iree/blob/main/samples/colab/edge_detection.ipynb.
//
// Input : a single 128x128 pixel image as a tensor<1x128x128x1xf32>, with pixels in [0.0, 1.0]
// Output: a single image in the same format after running edge detection

module {
  // CHECK-LABEL: EXEC @edge_detect_sobel_operator
  func.func @edge_detect_sobel_operator(%arg0: tensor<1x128x128x1xf32>) -> tensor<1x128x128x1xf32> {
    %0 = mhlo.constant dense<[[[[-1.000000e+00]], [[0.000000e+00]], [[1.000000e+00]]], [[[-2.000000e+00]], [[0.000000e+00]], [[2.000000e+00]]], [[[-1.000000e+00]], [[0.000000e+00]], [[1.000000e+00]]]]> : tensor<3x3x1x1xf32>
    %1 = mhlo.constant dense<[[[[1.000000e+00]], [[2.000000e+00]], [[1.000000e+00]]], [[[0.000000e+00]], [[0.000000e+00]], [[0.000000e+00]]], [[[-1.000000e+00]], [[-2.000000e+00]], [[-1.000000e+00]]]]> : tensor<3x3x1x1xf32>
    %2 = "mhlo.convolution"(%arg0, %0) {batch_group_count = 1 : i64, dimension_numbers = #mhlo.conv<raw input_batch_dimension = 0, input_feature_dimension = 3, input_spatial_dimensions = [1, 2], kernel_input_feature_dimension = 2, kernel_output_feature_dimension = 3, kernel_spatial_dimensions = [0, 1], output_batch_dimension = 0, output_feature_dimension = 3, output_spatial_dimensions = [1, 2]>, feature_group_count = 1 : i64, padding = dense<1> : tensor<2x2xi64>, rhs_dilation = dense<1> : tensor<2xi64>, window_strides = dense<1> : tensor<2xi64>} : (tensor<1x128x128x1xf32>, tensor<3x3x1x1xf32>) -> tensor<1x128x128x1xf32>
    %3 = mhlo.multiply %2, %2 : tensor<1x128x128x1xf32>
    %4 = "mhlo.convolution"(%arg0, %1) {batch_group_count = 1 : i64, dimension_numbers = #mhlo.conv<raw input_batch_dimension = 0, input_feature_dimension = 3, input_spatial_dimensions = [1, 2], kernel_input_feature_dimension = 2, kernel_output_feature_dimension = 3, kernel_spatial_dimensions = [0, 1], output_batch_dimension = 0, output_feature_dimension = 3, output_spatial_dimensions = [1, 2]>, feature_group_count = 1 : i64, padding = dense<1> : tensor<2x2xi64>, rhs_dilation = dense<1> : tensor<2xi64>, window_strides = dense<1> : tensor<2xi64>} : (tensor<1x128x128x1xf32>, tensor<3x3x1x1xf32>) -> tensor<1x128x128x1xf32>
    %5 = mhlo.multiply %4, %4 : tensor<1x128x128x1xf32>
    %6 = mhlo.add %3, %5 : tensor<1x128x128x1xf32>
    %7 = "mhlo.sqrt"(%6) : (tensor<1x128x128x1xf32>) -> tensor<1x128x128x1xf32>
    return %7 : tensor<1x128x128x1xf32>
  }
  // CHECK: 1x128x128x1xf32=
}
