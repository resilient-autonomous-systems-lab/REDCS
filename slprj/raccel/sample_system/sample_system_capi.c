#include "rtw_capi.h"
#ifdef HOST_CAPI_BUILD
#include "sample_system_capi_host.h"
#define sizeof(s) ((size_t)(0xFFFF))
#undef rt_offsetof
#define rt_offsetof(s,el) ((uint16_T)(0xFFFF))
#define TARGET_CONST
#define TARGET_STRING(s) (s)
#ifndef SS_UINT64
#define SS_UINT64 17
#endif
#ifndef SS_INT64
#define SS_INT64 18
#endif
#else
#include "builtin_typeid_types.h"
#include "sample_system.h"
#include "sample_system_capi.h"
#include "sample_system_private.h"
#ifdef LIGHT_WEIGHT_CAPI
#define TARGET_CONST
#define TARGET_STRING(s)               ((NULL))
#else
#define TARGET_CONST                   const
#define TARGET_STRING(s)               (s)
#endif
#endif
static const rtwCAPI_Signals rtBlockSignals [ ] = { { 0 , 1 , TARGET_STRING (
"sample_system/Attack Signals" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 0 }
, { 1 , 2 , TARGET_STRING ( "sample_system/Luenberger obsevre" ) ,
TARGET_STRING ( "" ) , 0 , 0 , 1 , 0 , 0 } , { 2 , 3 , TARGET_STRING (
"sample_system/observer_residual" ) , TARGET_STRING ( "" ) , 0 , 0 , 2 , 0 ,
0 } , { 3 , 4 , TARGET_STRING ( "sample_system/system dynamics" ) ,
TARGET_STRING ( "" ) , 0 , 0 , 1 , 0 , 0 } , { 4 , 5 , TARGET_STRING (
"sample_system/system outputs" ) , TARGET_STRING ( "" ) , 1 , 0 , 2 , 0 , 0 }
, { 5 , 0 , TARGET_STRING ( "sample_system/Clock1" ) , TARGET_STRING ( "" ) ,
0 , 0 , 2 , 0 , 0 } , { 6 , 0 , TARGET_STRING ( "sample_system/Gain" ) ,
TARGET_STRING ( "" ) , 0 , 0 , 1 , 0 , 0 } , { 7 , 0 , TARGET_STRING (
"sample_system/Integrator" ) , TARGET_STRING ( "" ) , 0 , 0 , 1 , 0 , 0 } , {
8 , 0 , TARGET_STRING ( "sample_system/Integrator1" ) , TARGET_STRING ( "" )
, 0 , 0 , 1 , 0 , 0 } , { 9 , 0 , TARGET_STRING ( "sample_system/Product" ) ,
TARGET_STRING ( "" ) , 0 , 0 , 2 , 0 , 1 } , { 10 , 0 , TARGET_STRING (
"sample_system/Product1" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 0 } , {
11 , 0 , TARGET_STRING ( "sample_system/Product7" ) , TARGET_STRING ( "" ) ,
0 , 0 , 0 , 0 , 0 } , { 12 , 0 , TARGET_STRING (
"sample_system/Relational Operator2" ) , TARGET_STRING ( "" ) , 0 , 1 , 2 , 0
, 2 } , { 13 , 0 , TARGET_STRING ( "sample_system/Sum" ) , TARGET_STRING ( ""
) , 0 , 0 , 0 , 0 , 0 } , { 14 , 0 , TARGET_STRING ( "sample_system/Sum2" ) ,
TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 0 } , { 0 , 0 , ( NULL ) , ( NULL ) ,
0 , 0 , 0 , 0 , 0 } } ; static const rtwCAPI_BlockParameters
rtBlockParameters [ ] = { { 15 , TARGET_STRING (
"sample_system/Uniform Random Number" ) , TARGET_STRING ( "Minimum" ) , 0 , 2
, 0 } , { 16 , TARGET_STRING ( "sample_system/Uniform Random Number" ) ,
TARGET_STRING ( "Maximum" ) , 0 , 2 , 0 } , { 0 , ( NULL ) , ( NULL ) , 0 , 0
, 0 } } ; static int_T rt_LoggedStateIdxList [ ] = { - 1 } ; static const
rtwCAPI_Signals rtRootInputs [ ] = { { 0 , 0 , ( NULL ) , ( NULL ) , 0 , 0 ,
0 , 0 , 0 } } ; static const rtwCAPI_Signals rtRootOutputs [ ] = { { 0 , 0 ,
( NULL ) , ( NULL ) , 0 , 0 , 0 , 0 , 0 } } ; static const
rtwCAPI_ModelParameters rtModelParameters [ ] = { { 17 , TARGET_STRING ( "A"
) , 0 , 3 , 0 } , { 18 , TARGET_STRING ( "B" ) , 0 , 3 , 0 } , { 19 ,
TARGET_STRING ( "C" ) , 0 , 4 , 0 } , { 20 , TARGET_STRING ( "Cc" ) , 0 , 5 ,
0 } , { 21 , TARGET_STRING ( "K" ) , 0 , 3 , 0 } , { 22 , TARGET_STRING ( "L"
) , 0 , 6 , 0 } , { 23 , TARGET_STRING ( "attack_final_deviations" ) , 0 , 7
, 0 } , { 24 , TARGET_STRING ( "attack_full_times" ) , 0 , 7 , 0 } , { 25 ,
TARGET_STRING ( "attack_start_times" ) , 0 , 7 , 0 } , { 26 , TARGET_STRING (
"detection_start" ) , 0 , 2 , 0 } , { 27 , TARGET_STRING ( "noise_seed" ) , 0
, 2 , 0 } , { 28 , TARGET_STRING ( "noise_trigger" ) , 0 , 2 , 0 } , { 29 ,
TARGET_STRING ( "x0" ) , 0 , 1 , 0 } , { 30 , TARGET_STRING ( "x_hat0" ) , 0
, 1 , 0 } , { 0 , ( NULL ) , 0 , 0 , 0 } } ;
#ifndef HOST_CAPI_BUILD
static void * rtDataAddrMap [ ] = { & rtB . bhepmgnidu [ 0 ] , & rtB .
garaq0p5sy [ 0 ] , & rtB . mmuv5cxhlj , & rtB . gjagphk3li [ 0 ] , & rtB .
nty1qxc5vr , & rtB . a5gud440br , & rtB . ojn1npo3a4 [ 0 ] , & rtB .
mgua5brbul [ 0 ] , & rtB . cb5s42cp3o [ 0 ] , & rtB . m2hykcpgz2 , & rtB .
a3di22nq4d [ 0 ] , & rtB . lsafowoqzm [ 0 ] , & rtB . mphsseyujn , & rtB .
mg5eyxlygw [ 0 ] , & rtB . avbnkdzwhd [ 0 ] , & rtP .
UniformRandomNumber_Minimum , & rtP . UniformRandomNumber_Maximum , & rtP . A
[ 0 ] , & rtP . B [ 0 ] , & rtP . C [ 0 ] , & rtP . Cc [ 0 ] , & rtP . K [ 0
] , & rtP . L [ 0 ] , & rtP . attack_final_deviations [ 0 ] , & rtP .
attack_full_times [ 0 ] , & rtP . attack_start_times [ 0 ] , & rtP .
detection_start , & rtP . noise_seed , & rtP . noise_trigger , & rtP . x0 [ 0
] , & rtP . x_hat0 [ 0 ] , } ; static int32_T * rtVarDimsAddrMap [ ] = { (
NULL ) } ;
#endif
static TARGET_CONST rtwCAPI_DataTypeMap rtDataTypeMap [ ] = { { "double" ,
"real_T" , 0 , 0 , sizeof ( real_T ) , ( uint8_T ) SS_DOUBLE , 0 , 0 , 0 } ,
{ "unsigned char" , "boolean_T" , 0 , 0 , sizeof ( boolean_T ) , ( uint8_T )
SS_BOOLEAN , 0 , 0 , 0 } } ;
#ifdef HOST_CAPI_BUILD
#undef sizeof
#endif
static TARGET_CONST rtwCAPI_ElementMap rtElementMap [ ] = { { ( NULL ) , 0 ,
0 , 0 , 0 } , } ; static const rtwCAPI_DimensionMap rtDimensionMap [ ] = { {
rtwCAPI_MATRIX_COL_MAJOR , 0 , 2 , 0 } , { rtwCAPI_VECTOR , 2 , 2 , 0 } , {
rtwCAPI_SCALAR , 4 , 2 , 0 } , { rtwCAPI_MATRIX_COL_MAJOR , 6 , 2 , 0 } , {
rtwCAPI_MATRIX_COL_MAJOR , 8 , 2 , 0 } , { rtwCAPI_VECTOR , 10 , 2 , 0 } , {
rtwCAPI_MATRIX_COL_MAJOR , 12 , 2 , 0 } , { rtwCAPI_VECTOR , 0 , 2 , 0 } } ;
static const uint_T rtDimensionArray [ ] = { 61 , 1 , 10 , 1 , 1 , 1 , 10 ,
10 , 61 , 10 , 1 , 10 , 10 , 61 } ; static const real_T rtcapiStoredFloats [
] = { 0.0 , 0.01 , 1.0 } ; static const rtwCAPI_FixPtMap rtFixPtMap [ ] = { {
( NULL ) , ( NULL ) , rtwCAPI_FIX_RESERVED , 0 , 0 , ( boolean_T ) 0 } , } ;
static const rtwCAPI_SampleTimeMap rtSampleTimeMap [ ] = { { ( const void * )
& rtcapiStoredFloats [ 0 ] , ( const void * ) & rtcapiStoredFloats [ 0 ] , (
int8_T ) 0 , ( uint8_T ) 0 } , { ( const void * ) & rtcapiStoredFloats [ 1 ]
, ( const void * ) & rtcapiStoredFloats [ 0 ] , ( int8_T ) 2 , ( uint8_T ) 0
} , { ( const void * ) & rtcapiStoredFloats [ 0 ] , ( const void * ) &
rtcapiStoredFloats [ 2 ] , ( int8_T ) 1 , ( uint8_T ) 0 } } ; static
rtwCAPI_ModelMappingStaticInfo mmiStatic = { { rtBlockSignals , 15 ,
rtRootInputs , 0 , rtRootOutputs , 0 } , { rtBlockParameters , 2 ,
rtModelParameters , 14 } , { ( NULL ) , 0 } , { rtDataTypeMap ,
rtDimensionMap , rtFixPtMap , rtElementMap , rtSampleTimeMap ,
rtDimensionArray } , "float" , { 2693835777U , 872802496U , 4133713670U ,
3670903414U } , ( NULL ) , 0 , ( boolean_T ) 0 , rt_LoggedStateIdxList } ;
const rtwCAPI_ModelMappingStaticInfo * sample_system_GetCAPIStaticMap ( void
) { return & mmiStatic ; }
#ifndef HOST_CAPI_BUILD
void sample_system_InitializeDataMapInfo ( void ) { rtwCAPI_SetVersion ( ( *
rt_dataMapInfoPtr ) . mmi , 1 ) ; rtwCAPI_SetStaticMap ( ( *
rt_dataMapInfoPtr ) . mmi , & mmiStatic ) ; rtwCAPI_SetLoggingStaticMap ( ( *
rt_dataMapInfoPtr ) . mmi , ( NULL ) ) ; rtwCAPI_SetDataAddressMap ( ( *
rt_dataMapInfoPtr ) . mmi , rtDataAddrMap ) ; rtwCAPI_SetVarDimsAddressMap (
( * rt_dataMapInfoPtr ) . mmi , rtVarDimsAddrMap ) ;
rtwCAPI_SetInstanceLoggingInfo ( ( * rt_dataMapInfoPtr ) . mmi , ( NULL ) ) ;
rtwCAPI_SetChildMMIArray ( ( * rt_dataMapInfoPtr ) . mmi , ( NULL ) ) ;
rtwCAPI_SetChildMMIArrayLen ( ( * rt_dataMapInfoPtr ) . mmi , 0 ) ; }
#else
#ifdef __cplusplus
extern "C" {
#endif
void sample_system_host_InitializeDataMapInfo (
sample_system_host_DataMapInfo_T * dataMap , const char * path ) {
rtwCAPI_SetVersion ( dataMap -> mmi , 1 ) ; rtwCAPI_SetStaticMap ( dataMap ->
mmi , & mmiStatic ) ; rtwCAPI_SetDataAddressMap ( dataMap -> mmi , ( NULL ) )
; rtwCAPI_SetVarDimsAddressMap ( dataMap -> mmi , ( NULL ) ) ;
rtwCAPI_SetPath ( dataMap -> mmi , path ) ; rtwCAPI_SetFullPath ( dataMap ->
mmi , ( NULL ) ) ; rtwCAPI_SetChildMMIArray ( dataMap -> mmi , ( NULL ) ) ;
rtwCAPI_SetChildMMIArrayLen ( dataMap -> mmi , 0 ) ; }
#ifdef __cplusplus
}
#endif
#endif
