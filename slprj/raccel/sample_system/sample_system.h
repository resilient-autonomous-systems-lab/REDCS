#ifndef RTW_HEADER_sample_system_h_
#define RTW_HEADER_sample_system_h_
#ifndef sample_system_COMMON_INCLUDES_
#define sample_system_COMMON_INCLUDES_
#include <stdlib.h>
#include "sl_AsyncioQueue/AsyncioQueueCAPI.h"
#include "rtwtypes.h"
#include "sigstream_rtw.h"
#include "simtarget/slSimTgtSigstreamRTW.h"
#include "simtarget/slSimTgtSlioCoreRTW.h"
#include "simtarget/slSimTgtSlioClientsRTW.h"
#include "simtarget/slSimTgtSlioSdiRTW.h"
#include "simstruc.h"
#include "fixedpoint.h"
#include "raccel.h"
#include "slsv_diagnostic_codegen_c_api.h"
#include "rt_logging_simtarget.h"
#include "dt_info.h"
#include "ext_work.h"
#endif
#include "sample_system_types.h"
#include <stddef.h>
#include "rtw_modelmap_simtarget.h"
#include "rt_defines.h"
#include <string.h>
#include "rtGetInf.h"
#include "rt_nonfinite.h"
#define MODEL_NAME sample_system
#define NSAMPLE_TIMES (4) 
#define NINPUTS (0)       
#define NOUTPUTS (0)     
#define NBLOCKIO (15) 
#define NUM_ZC_EVENTS (0) 
#ifndef NCSTATES
#define NCSTATES (20)   
#elif NCSTATES != 20
#error Invalid specification of NCSTATES defined in compiler command
#endif
#ifndef rtmGetDataMapInfo
#define rtmGetDataMapInfo(rtm) (*rt_dataMapInfoPtr)
#endif
#ifndef rtmSetDataMapInfo
#define rtmSetDataMapInfo(rtm, val) (rt_dataMapInfoPtr = &val)
#endif
#ifndef IN_RACCEL_MAIN
#endif
typedef struct { real_T m2hykcpgz2 ; real_T mgua5brbul [ 10 ] ; real_T
lsafowoqzm [ 61 ] ; real_T mg5eyxlygw [ 61 ] ; real_T a3di22nq4d [ 61 ] ;
real_T avbnkdzwhd [ 61 ] ; real_T a5gud440br ; real_T cb5s42cp3o [ 10 ] ;
real_T ojn1npo3a4 [ 10 ] ; real_T nty1qxc5vr ; real_T gjagphk3li [ 10 ] ;
real_T mmuv5cxhlj ; real_T garaq0p5sy [ 10 ] ; real_T bhepmgnidu [ 61 ] ;
boolean_T mphsseyujn ; } B ; typedef struct { real_T jflrz4f2zz ; struct {
void * LoggedData ; } ecs1y5aje0 ; struct { void * AQHandles ; } bk4qjslljc ;
struct { void * AQHandles ; } dcrpxoznep ; struct { void * AQHandles ; }
ds0uokuev3 ; struct { void * AQHandles ; } mqwlltnsif ; struct { void *
AQHandles ; } ht0kegwtt4 ; struct { void * LoggedData ; } os2t0qr0ej ; struct
{ void * LoggedData ; } ksiml4nejt ; struct { void * LoggedData ; }
johdteycds ; struct { void * LoggedData ; } pyr3adjohh ; struct { void *
LoggedData ; } jhwuxhzmgd ; struct { void * LoggedData ; } l1uxu5bmue ;
uint32_T jircoqfdva ; boolean_T fvuql44emp ; } DW ; typedef struct { real_T
hyb3of0a4n [ 10 ] ; real_T leyzn45qrb [ 10 ] ; } X ; typedef struct { real_T
hyb3of0a4n [ 10 ] ; real_T leyzn45qrb [ 10 ] ; } XDot ; typedef struct {
boolean_T hyb3of0a4n [ 10 ] ; boolean_T leyzn45qrb [ 10 ] ; } XDis ; typedef
struct { real_T hyb3of0a4n [ 10 ] ; real_T leyzn45qrb [ 10 ] ; } CStateAbsTol
; typedef struct { real_T hyb3of0a4n [ 10 ] ; real_T leyzn45qrb [ 10 ] ; }
CXPtMin ; typedef struct { real_T hyb3of0a4n [ 10 ] ; real_T leyzn45qrb [ 10
] ; } CXPtMax ; typedef struct { real_T fyn2dhfvj5 ; } ZCV ; typedef struct {
rtwCAPI_ModelMappingInfo mmi ; } DataMapInfo ; struct P_ { real_T A [ 100 ] ;
real_T B [ 100 ] ; real_T C [ 610 ] ; real_T Cc [ 10 ] ; real_T K [ 100 ] ;
real_T L [ 610 ] ; real_T attack_final_deviations [ 61 ] ; real_T
attack_full_times [ 61 ] ; real_T attack_start_times [ 61 ] ; real_T
detection_start ; real_T noise_seed ; real_T noise_trigger ; real_T x0 [ 10 ]
; real_T x_hat0 [ 10 ] ; real_T UniformRandomNumber_Minimum ; real_T
UniformRandomNumber_Maximum ; } ; extern const char *
RT_MEMORY_ALLOCATION_ERROR ; extern B rtB ; extern X rtX ; extern DW rtDW ;
extern P rtP ; extern mxArray * mr_sample_system_GetDWork ( ) ; extern void
mr_sample_system_SetDWork ( const mxArray * ssDW ) ; extern mxArray *
mr_sample_system_GetSimStateDisallowedBlocks ( ) ; extern const
rtwCAPI_ModelMappingStaticInfo * sample_system_GetCAPIStaticMap ( void ) ;
extern SimStruct * const rtS ; extern const int_T gblNumToFiles ; extern
const int_T gblNumFrFiles ; extern const int_T gblNumFrWksBlocks ; extern
rtInportTUtable * gblInportTUtables ; extern const char * gblInportFileName ;
extern const int_T gblNumRootInportBlks ; extern const int_T
gblNumModelInputs ; extern const int_T gblInportDataTypeIdx [ ] ; extern
const int_T gblInportDims [ ] ; extern const int_T gblInportComplex [ ] ;
extern const int_T gblInportInterpoFlag [ ] ; extern const int_T
gblInportContinuous [ ] ; extern const int_T gblParameterTuningTid ; extern
DataMapInfo * rt_dataMapInfoPtr ; extern rtwCAPI_ModelMappingInfo *
rt_modelMapInfoPtr ; void MdlOutputs ( int_T tid ) ; void
MdlOutputsParameterSampleTime ( int_T tid ) ; void MdlUpdate ( int_T tid ) ;
void MdlTerminate ( void ) ; void MdlInitializeSizes ( void ) ; void
MdlInitializeSampleTimes ( void ) ; SimStruct * raccel_register_model (
ssExecutionInfo * executionInfo ) ;
#endif
