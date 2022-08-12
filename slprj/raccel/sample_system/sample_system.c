#include "sample_system.h"
#include "rtwtypes.h"
#include "mwmathutil.h"
#include "sample_system_private.h"
#include <string.h>
#include "rt_logging_mmi.h"
#include "sample_system_capi.h"
#include "sample_system_dt.h"
extern void * CreateDiagnosticAsVoidPtr_wrapper ( const char * id , int nargs
, ... ) ; RTWExtModeInfo * gblRTWExtModeInfo = NULL ; void
raccelForceExtModeShutdown ( boolean_T extModeStartPktReceived ) { if ( !
extModeStartPktReceived ) { boolean_T stopRequested = false ;
rtExtModeWaitForStartPkt ( gblRTWExtModeInfo , 3 , & stopRequested ) ; }
rtExtModeShutdown ( 3 ) ; }
#include "slsv_diagnostic_codegen_c_api.h"
#include "slsa_sim_engine.h"
const int_T gblNumToFiles = 0 ; const int_T gblNumFrFiles = 0 ; const int_T
gblNumFrWksBlocks = 0 ;
#ifdef RSIM_WITH_SOLVER_MULTITASKING
boolean_T gbl_raccel_isMultitasking = 1 ;
#else
boolean_T gbl_raccel_isMultitasking = 0 ;
#endif
boolean_T gbl_raccel_tid01eq = 0 ; int_T gbl_raccel_NumST = 4 ; const char_T
* gbl_raccel_Version = "9.7 (R2022a) 13-Nov-2021" ; void
raccel_setup_MMIStateLog ( SimStruct * S ) {
#ifdef UseMMIDataLogging
rt_FillStateSigInfoFromMMI ( ssGetRTWLogInfo ( S ) , & ssGetErrorStatus ( S )
) ;
#else
UNUSED_PARAMETER ( S ) ;
#endif
} static DataMapInfo rt_dataMapInfo ; DataMapInfo * rt_dataMapInfoPtr = &
rt_dataMapInfo ; rtwCAPI_ModelMappingInfo * rt_modelMapInfoPtr = & (
rt_dataMapInfo . mmi ) ; const int_T gblNumRootInportBlks = 0 ; const int_T
gblNumModelInputs = 0 ; extern const char * gblInportFileName ; extern
rtInportTUtable * gblInportTUtables ; const int_T gblInportDataTypeIdx [ ] =
{ - 1 } ; const int_T gblInportDims [ ] = { - 1 } ; const int_T
gblInportComplex [ ] = { - 1 } ; const int_T gblInportInterpoFlag [ ] = { - 1
} ; const int_T gblInportContinuous [ ] = { - 1 } ; int_T enableFcnCallFlag [
] = { 1 , 1 , 1 , 1 } ; const char * raccelLoadInputsAndAperiodicHitTimes (
SimStruct * S , const char * inportFileName , int * matFileFormat ) { return
rt_RAccelReadInportsMatFile ( S , inportFileName , matFileFormat ) ; }
#include "simstruc.h"
#include "fixedpoint.h"
#include "slsa_sim_engine.h"
#include "simtarget/slSimTgtSLExecSimBridge.h"
B rtB ; X rtX ; DW rtDW ; static SimStruct model_S ; SimStruct * const rtS =
& model_S ; real_T rt_urand_Upu32_Yd_f_pw_snf ( uint32_T * u ) { uint32_T hi
; uint32_T lo ; lo = * u % 127773U * 16807U ; hi = * u / 127773U * 2836U ; if
( lo < hi ) { * u = 2147483647U - ( hi - lo ) ; } else { * u = lo - hi ; }
return ( real_T ) * u * 4.6566128752457969E-10 ; } void MdlInitialize ( void
) { real_T tmp ; int32_T i ; int32_T t ; uint32_T tseed ; tmp =
muDoubleScalarFloor ( rtP . noise_seed ) ; if ( muDoubleScalarIsNaN ( tmp )
|| muDoubleScalarIsInf ( tmp ) ) { tmp = 0.0 ; } else { tmp =
muDoubleScalarRem ( tmp , 4.294967296E+9 ) ; } tseed = tmp < 0.0 ? ( uint32_T
) - ( int32_T ) ( uint32_T ) - tmp : ( uint32_T ) tmp ; i = ( int32_T ) (
tseed >> 16U ) ; t = ( int32_T ) ( tseed & 32768U ) ; tseed = ( ( ( ( tseed -
( ( uint32_T ) i << 16U ) ) + t ) << 16U ) + t ) + i ; if ( tseed < 1U ) {
tseed = 1144108930U ; } else if ( tseed > 2147483646U ) { tseed = 2147483646U
; } rtDW . jircoqfdva = tseed ; rtDW . jflrz4f2zz = ( rtP .
UniformRandomNumber_Maximum - rtP . UniformRandomNumber_Minimum ) *
rt_urand_Upu32_Yd_f_pw_snf ( & rtDW . jircoqfdva ) + rtP .
UniformRandomNumber_Minimum ; memcpy ( & rtX . hyb3of0a4n [ 0 ] , & rtP . x0
[ 0 ] , 10U * sizeof ( real_T ) ) ; memcpy ( & rtX . leyzn45qrb [ 0 ] , & rtP
. x_hat0 [ 0 ] , 10U * sizeof ( real_T ) ) ; } void MdlStart ( void ) { {
bool externalInputIsInDatasetFormat = false ; void * pISigstreamManager =
rt_GetISigstreamManager ( rtS ) ;
rtwISigstreamManagerGetInputIsInDatasetFormat ( pISigstreamManager , &
externalInputIsInDatasetFormat ) ; if ( externalInputIsInDatasetFormat ) { }
} { { { bool isStreamoutAlreadyRegistered = false ; { sdiSignalSourceInfoU
srcInfo ; sdiLabelU loggedName = sdiGetLabelFromChars ( "Product5" ) ;
sdiLabelU origSigName = sdiGetLabelFromChars ( "" ) ; sdiLabelU propName =
sdiGetLabelFromChars ( "Product5" ) ; sdiLabelU blockPath =
sdiGetLabelFromChars ( "sample_system/To Workspace" ) ; sdiLabelU blockSID =
sdiGetLabelFromChars ( "" ) ; sdiLabelU subPath = sdiGetLabelFromChars ( "" )
; sdiDims sigDims ; sdiLabelU sigName = sdiGetLabelFromChars ( "Product5" ) ;
sdiAsyncRepoDataTypeHandle hDT = sdiAsyncRepoGetBuiltInDataTypeHandle (
DATA_TYPE_DOUBLE ) ; { sdiComplexity sigComplexity = REAL ;
sdiSampleTimeContinuity stCont = SAMPLE_TIME_CONTINUOUS ; int_T sigDimsArray
[ 2 ] = { 61 , 1 } ; sigDims . nDims = 2 ; sigDims . dimensions =
sigDimsArray ; srcInfo . numBlockPathElems = 1 ; srcInfo . fullBlockPath = (
sdiFullBlkPathU ) & blockPath ; srcInfo . SID = ( sdiSignalIDU ) & blockSID ;
srcInfo . subPath = subPath ; srcInfo . portIndex = 0 + 1 ; srcInfo .
signalName = sigName ; srcInfo . sigSourceUUID = 0 ; rtDW . bk4qjslljc .
AQHandles = sdiStartAsyncioQueueCreation ( hDT , & srcInfo , rt_dataMapInfo .
mmi . InstanceMap . fullPath , "69e20973-bb78-4ffe-8ebf-680eed74f0ad" ,
sigComplexity , & sigDims , DIMENSIONS_MODE_FIXED , stCont , "" ) ;
sdiCompleteAsyncioQueueCreation ( rtDW . bk4qjslljc . AQHandles , hDT , &
srcInfo ) ; if ( rtDW . bk4qjslljc . AQHandles ) {
sdiSetSignalSampleTimeString ( rtDW . bk4qjslljc . AQHandles , "Continuous" ,
0.0 , ssGetTFinal ( rtS ) ) ; sdiSetSignalRefRate ( rtDW . bk4qjslljc .
AQHandles , 0.0 ) ; sdiSetRunStartTime ( rtDW . bk4qjslljc . AQHandles ,
ssGetTaskTime ( rtS , 0 ) ) ; sdiAsyncRepoSetSignalExportSettings ( rtDW .
bk4qjslljc . AQHandles , 1 , 0 ) ; sdiAsyncRepoSetSignalExportName ( rtDW .
bk4qjslljc . AQHandles , loggedName , origSigName , propName ) ;
sdiAsyncRepoSetBlockPathDomain ( rtDW . bk4qjslljc . AQHandles ) ; }
sdiFreeLabel ( sigName ) ; sdiFreeLabel ( loggedName ) ; sdiFreeLabel (
origSigName ) ; sdiFreeLabel ( propName ) ; sdiFreeLabel ( blockPath ) ;
sdiFreeLabel ( blockSID ) ; sdiFreeLabel ( subPath ) ; } } if ( !
isStreamoutAlreadyRegistered ) { { sdiLabelU varName = sdiGetLabelFromChars (
"measurements" ) ; sdiRegisterWksVariable ( rtDW . bk4qjslljc . AQHandles ,
varName , "timeseries" ) ; sdiFreeLabel ( varName ) ; } } } } } { { { bool
isStreamoutAlreadyRegistered = false ; { sdiSignalSourceInfoU srcInfo ;
sdiLabelU loggedName = sdiGetLabelFromChars ( "Product2" ) ; sdiLabelU
origSigName = sdiGetLabelFromChars ( "" ) ; sdiLabelU propName =
sdiGetLabelFromChars ( "Product2" ) ; sdiLabelU blockPath =
sdiGetLabelFromChars ( "sample_system/To Workspace1" ) ; sdiLabelU blockSID =
sdiGetLabelFromChars ( "" ) ; sdiLabelU subPath = sdiGetLabelFromChars ( "" )
; sdiDims sigDims ; sdiLabelU sigName = sdiGetLabelFromChars ( "Product2" ) ;
sdiAsyncRepoDataTypeHandle hDT = sdiAsyncRepoGetBuiltInDataTypeHandle (
DATA_TYPE_DOUBLE ) ; { sdiComplexity sigComplexity = REAL ;
sdiSampleTimeContinuity stCont = SAMPLE_TIME_CONTINUOUS ; int_T sigDimsArray
[ 1 ] = { 10 } ; sigDims . nDims = 1 ; sigDims . dimensions = sigDimsArray ;
srcInfo . numBlockPathElems = 1 ; srcInfo . fullBlockPath = ( sdiFullBlkPathU
) & blockPath ; srcInfo . SID = ( sdiSignalIDU ) & blockSID ; srcInfo .
subPath = subPath ; srcInfo . portIndex = 0 + 1 ; srcInfo . signalName =
sigName ; srcInfo . sigSourceUUID = 0 ; rtDW . dcrpxoznep . AQHandles =
sdiStartAsyncioQueueCreation ( hDT , & srcInfo , rt_dataMapInfo . mmi .
InstanceMap . fullPath , "dac5cb8a-5955-4d60-a327-4a91c1fe84ca" ,
sigComplexity , & sigDims , DIMENSIONS_MODE_FIXED , stCont , "" ) ;
sdiCompleteAsyncioQueueCreation ( rtDW . dcrpxoznep . AQHandles , hDT , &
srcInfo ) ; if ( rtDW . dcrpxoznep . AQHandles ) {
sdiSetSignalSampleTimeString ( rtDW . dcrpxoznep . AQHandles , "Continuous" ,
0.0 , ssGetTFinal ( rtS ) ) ; sdiSetSignalRefRate ( rtDW . dcrpxoznep .
AQHandles , 0.0 ) ; sdiSetRunStartTime ( rtDW . dcrpxoznep . AQHandles ,
ssGetTaskTime ( rtS , 0 ) ) ; sdiAsyncRepoSetSignalExportSettings ( rtDW .
dcrpxoznep . AQHandles , 1 , 0 ) ; sdiAsyncRepoSetSignalExportName ( rtDW .
dcrpxoznep . AQHandles , loggedName , origSigName , propName ) ;
sdiAsyncRepoSetBlockPathDomain ( rtDW . dcrpxoznep . AQHandles ) ; }
sdiFreeLabel ( sigName ) ; sdiFreeLabel ( loggedName ) ; sdiFreeLabel (
origSigName ) ; sdiFreeLabel ( propName ) ; sdiFreeLabel ( blockPath ) ;
sdiFreeLabel ( blockSID ) ; sdiFreeLabel ( subPath ) ; } } if ( !
isStreamoutAlreadyRegistered ) { { sdiLabelU varName = sdiGetLabelFromChars (
"states" ) ; sdiRegisterWksVariable ( rtDW . dcrpxoznep . AQHandles , varName
, "timeseries" ) ; sdiFreeLabel ( varName ) ; } } } } } { { { bool
isStreamoutAlreadyRegistered = false ; { sdiSignalSourceInfoU srcInfo ;
sdiLabelU loggedName = sdiGetLabelFromChars ( "Product4" ) ; sdiLabelU
origSigName = sdiGetLabelFromChars ( "" ) ; sdiLabelU propName =
sdiGetLabelFromChars ( "Product4" ) ; sdiLabelU blockPath =
sdiGetLabelFromChars ( "sample_system/To Workspace2" ) ; sdiLabelU blockSID =
sdiGetLabelFromChars ( "" ) ; sdiLabelU subPath = sdiGetLabelFromChars ( "" )
; sdiDims sigDims ; sdiLabelU sigName = sdiGetLabelFromChars ( "Product4" ) ;
sdiAsyncRepoDataTypeHandle hDT = sdiAsyncRepoGetBuiltInDataTypeHandle (
DATA_TYPE_DOUBLE ) ; { sdiComplexity sigComplexity = REAL ;
sdiSampleTimeContinuity stCont = SAMPLE_TIME_CONTINUOUS ; int_T sigDimsArray
[ 1 ] = { 1 } ; sigDims . nDims = 1 ; sigDims . dimensions = sigDimsArray ;
srcInfo . numBlockPathElems = 1 ; srcInfo . fullBlockPath = ( sdiFullBlkPathU
) & blockPath ; srcInfo . SID = ( sdiSignalIDU ) & blockSID ; srcInfo .
subPath = subPath ; srcInfo . portIndex = 0 + 1 ; srcInfo . signalName =
sigName ; srcInfo . sigSourceUUID = 0 ; rtDW . ds0uokuev3 . AQHandles =
sdiStartAsyncioQueueCreation ( hDT , & srcInfo , rt_dataMapInfo . mmi .
InstanceMap . fullPath , "ad490ab9-9223-48c2-b37d-35893e9ff907" ,
sigComplexity , & sigDims , DIMENSIONS_MODE_FIXED , stCont , "" ) ;
sdiCompleteAsyncioQueueCreation ( rtDW . ds0uokuev3 . AQHandles , hDT , &
srcInfo ) ; if ( rtDW . ds0uokuev3 . AQHandles ) {
sdiSetSignalSampleTimeString ( rtDW . ds0uokuev3 . AQHandles , "Continuous" ,
0.0 , ssGetTFinal ( rtS ) ) ; sdiSetSignalRefRate ( rtDW . ds0uokuev3 .
AQHandles , 0.0 ) ; sdiSetRunStartTime ( rtDW . ds0uokuev3 . AQHandles ,
ssGetTaskTime ( rtS , 0 ) ) ; sdiAsyncRepoSetSignalExportSettings ( rtDW .
ds0uokuev3 . AQHandles , 1 , 0 ) ; sdiAsyncRepoSetSignalExportName ( rtDW .
ds0uokuev3 . AQHandles , loggedName , origSigName , propName ) ;
sdiAsyncRepoSetBlockPathDomain ( rtDW . ds0uokuev3 . AQHandles ) ; }
sdiFreeLabel ( sigName ) ; sdiFreeLabel ( loggedName ) ; sdiFreeLabel (
origSigName ) ; sdiFreeLabel ( propName ) ; sdiFreeLabel ( blockPath ) ;
sdiFreeLabel ( blockSID ) ; sdiFreeLabel ( subPath ) ; } } if ( !
isStreamoutAlreadyRegistered ) { { sdiLabelU varName = sdiGetLabelFromChars (
"critical_measurement" ) ; sdiRegisterWksVariable ( rtDW . ds0uokuev3 .
AQHandles , varName , "timeseries" ) ; sdiFreeLabel ( varName ) ; } } } } } {
{ { bool isStreamoutAlreadyRegistered = false ; { sdiSignalSourceInfoU
srcInfo ; sdiLabelU loggedName = sdiGetLabelFromChars ( "Product3" ) ;
sdiLabelU origSigName = sdiGetLabelFromChars ( "" ) ; sdiLabelU propName =
sdiGetLabelFromChars ( "Product3" ) ; sdiLabelU blockPath =
sdiGetLabelFromChars ( "sample_system/To Workspace3" ) ; sdiLabelU blockSID =
sdiGetLabelFromChars ( "" ) ; sdiLabelU subPath = sdiGetLabelFromChars ( "" )
; sdiDims sigDims ; sdiLabelU sigName = sdiGetLabelFromChars ( "Product3" ) ;
sdiAsyncRepoDataTypeHandle hDT = sdiAsyncRepoGetBuiltInDataTypeHandle (
DATA_TYPE_DOUBLE ) ; { sdiComplexity sigComplexity = REAL ;
sdiSampleTimeContinuity stCont = SAMPLE_TIME_CONTINUOUS ; int_T sigDimsArray
[ 1 ] = { 10 } ; sigDims . nDims = 1 ; sigDims . dimensions = sigDimsArray ;
srcInfo . numBlockPathElems = 1 ; srcInfo . fullBlockPath = ( sdiFullBlkPathU
) & blockPath ; srcInfo . SID = ( sdiSignalIDU ) & blockSID ; srcInfo .
subPath = subPath ; srcInfo . portIndex = 0 + 1 ; srcInfo . signalName =
sigName ; srcInfo . sigSourceUUID = 0 ; rtDW . mqwlltnsif . AQHandles =
sdiStartAsyncioQueueCreation ( hDT , & srcInfo , rt_dataMapInfo . mmi .
InstanceMap . fullPath , "e1af9f74-0c60-48e8-a74a-a062ec2ef6c0" ,
sigComplexity , & sigDims , DIMENSIONS_MODE_FIXED , stCont , "" ) ;
sdiCompleteAsyncioQueueCreation ( rtDW . mqwlltnsif . AQHandles , hDT , &
srcInfo ) ; if ( rtDW . mqwlltnsif . AQHandles ) {
sdiSetSignalSampleTimeString ( rtDW . mqwlltnsif . AQHandles , "Continuous" ,
0.0 , ssGetTFinal ( rtS ) ) ; sdiSetSignalRefRate ( rtDW . mqwlltnsif .
AQHandles , 0.0 ) ; sdiSetRunStartTime ( rtDW . mqwlltnsif . AQHandles ,
ssGetTaskTime ( rtS , 0 ) ) ; sdiAsyncRepoSetSignalExportSettings ( rtDW .
mqwlltnsif . AQHandles , 1 , 0 ) ; sdiAsyncRepoSetSignalExportName ( rtDW .
mqwlltnsif . AQHandles , loggedName , origSigName , propName ) ;
sdiAsyncRepoSetBlockPathDomain ( rtDW . mqwlltnsif . AQHandles ) ; }
sdiFreeLabel ( sigName ) ; sdiFreeLabel ( loggedName ) ; sdiFreeLabel (
origSigName ) ; sdiFreeLabel ( propName ) ; sdiFreeLabel ( blockPath ) ;
sdiFreeLabel ( blockSID ) ; sdiFreeLabel ( subPath ) ; } } if ( !
isStreamoutAlreadyRegistered ) { { sdiLabelU varName = sdiGetLabelFromChars (
"estimate" ) ; sdiRegisterWksVariable ( rtDW . mqwlltnsif . AQHandles ,
varName , "timeseries" ) ; sdiFreeLabel ( varName ) ; } } } } } { { { bool
isStreamoutAlreadyRegistered = false ; { sdiSignalSourceInfoU srcInfo ;
sdiLabelU loggedName = sdiGetLabelFromChars ( "Product6" ) ; sdiLabelU
origSigName = sdiGetLabelFromChars ( "" ) ; sdiLabelU propName =
sdiGetLabelFromChars ( "Product6" ) ; sdiLabelU blockPath =
sdiGetLabelFromChars ( "sample_system/To Workspace4" ) ; sdiLabelU blockSID =
sdiGetLabelFromChars ( "" ) ; sdiLabelU subPath = sdiGetLabelFromChars ( "" )
; sdiDims sigDims ; sdiLabelU sigName = sdiGetLabelFromChars ( "Product6" ) ;
sdiAsyncRepoDataTypeHandle hDT = sdiAsyncRepoGetBuiltInDataTypeHandle (
DATA_TYPE_DOUBLE ) ; { sdiComplexity sigComplexity = REAL ;
sdiSampleTimeContinuity stCont = SAMPLE_TIME_CONTINUOUS ; int_T sigDimsArray
[ 1 ] = { 1 } ; sigDims . nDims = 1 ; sigDims . dimensions = sigDimsArray ;
srcInfo . numBlockPathElems = 1 ; srcInfo . fullBlockPath = ( sdiFullBlkPathU
) & blockPath ; srcInfo . SID = ( sdiSignalIDU ) & blockSID ; srcInfo .
subPath = subPath ; srcInfo . portIndex = 0 + 1 ; srcInfo . signalName =
sigName ; srcInfo . sigSourceUUID = 0 ; rtDW . ht0kegwtt4 . AQHandles =
sdiStartAsyncioQueueCreation ( hDT , & srcInfo , rt_dataMapInfo . mmi .
InstanceMap . fullPath , "984a1a7a-96d8-4e5c-9f5f-2afceb551974" ,
sigComplexity , & sigDims , DIMENSIONS_MODE_FIXED , stCont , "" ) ;
sdiCompleteAsyncioQueueCreation ( rtDW . ht0kegwtt4 . AQHandles , hDT , &
srcInfo ) ; if ( rtDW . ht0kegwtt4 . AQHandles ) {
sdiSetSignalSampleTimeString ( rtDW . ht0kegwtt4 . AQHandles , "Continuous" ,
0.0 , ssGetTFinal ( rtS ) ) ; sdiSetSignalRefRate ( rtDW . ht0kegwtt4 .
AQHandles , 0.0 ) ; sdiSetRunStartTime ( rtDW . ht0kegwtt4 . AQHandles ,
ssGetTaskTime ( rtS , 0 ) ) ; sdiAsyncRepoSetSignalExportSettings ( rtDW .
ht0kegwtt4 . AQHandles , 1 , 0 ) ; sdiAsyncRepoSetSignalExportName ( rtDW .
ht0kegwtt4 . AQHandles , loggedName , origSigName , propName ) ;
sdiAsyncRepoSetBlockPathDomain ( rtDW . ht0kegwtt4 . AQHandles ) ; }
sdiFreeLabel ( sigName ) ; sdiFreeLabel ( loggedName ) ; sdiFreeLabel (
origSigName ) ; sdiFreeLabel ( propName ) ; sdiFreeLabel ( blockPath ) ;
sdiFreeLabel ( blockSID ) ; sdiFreeLabel ( subPath ) ; } } if ( !
isStreamoutAlreadyRegistered ) { { sdiLabelU varName = sdiGetLabelFromChars (
"residual" ) ; sdiRegisterWksVariable ( rtDW . ht0kegwtt4 . AQHandles ,
varName , "timeseries" ) ; sdiFreeLabel ( varName ) ; } } } } } MdlInitialize
( ) ; } void MdlOutputs ( int_T tid ) { real_T tmp_p [ 100 ] ; real_T
f0ngv3fxdj [ 61 ] ; real_T tmp [ 61 ] ; real_T dx4pk50v0m [ 10 ] ; real_T
tmp_e [ 10 ] ; real_T tmp_i [ 10 ] ; real_T tmp_m [ 10 ] ; real_T absxk ;
real_T g01cj55nt3 ; real_T t ; int32_T i ; int32_T k ; if ( ssIsSampleHit (
rtS , 2 , 0 ) ) { rtB . m2hykcpgz2 = rtP . noise_trigger * rtDW . jflrz4f2zz
; } memcpy ( & rtB . mgua5brbul [ 0 ] , & rtX . hyb3of0a4n [ 0 ] , 10U *
sizeof ( real_T ) ) ; for ( i = 0 ; i < 61 ; i ++ ) { tmp [ i ] = 0.0 ; for (
k = 0 ; k < 10 ; k ++ ) { tmp [ i ] += rtP . C [ 61 * k + i ] * rtB .
mgua5brbul [ k ] ; } f0ngv3fxdj [ i ] = tmp [ i ] ; } absxk = 0.0 ; for ( i =
0 ; i < 10 ; i ++ ) { absxk += rtP . Cc [ i ] * rtB . mgua5brbul [ i ] ; }
rtB . nty1qxc5vr = absxk ; g01cj55nt3 = ssGetT ( rtS ) ; for ( k = 0 ; k < 61
; k ++ ) { absxk = f0ngv3fxdj [ k ] ; rtB . lsafowoqzm [ k ] = rtB .
m2hykcpgz2 * absxk ; rtB . mg5eyxlygw [ k ] = rtB . lsafowoqzm [ k ] + absxk
; absxk = rtP . attack_full_times [ k ] - rtP . attack_start_times [ k ] ;
rtB . bhepmgnidu [ k ] = muDoubleScalarMax ( absxk , 0.0 ) ; rtB . bhepmgnidu
[ k ] = ( real_T ) ( ( g01cj55nt3 > rtP . attack_start_times [ k ] ) && (
g01cj55nt3 <= rtP . attack_full_times [ k ] ) ) * ( rtP .
attack_final_deviations [ k ] / rtB . bhepmgnidu [ k ] * ( g01cj55nt3 - rtP .
attack_start_times [ k ] ) ) + ( real_T ) ( g01cj55nt3 > rtP .
attack_full_times [ k ] ) * rtP . attack_final_deviations [ k ] ; rtB .
a3di22nq4d [ k ] = rtB . mg5eyxlygw [ k ] * rtB . bhepmgnidu [ k ] ; rtB .
avbnkdzwhd [ k ] = rtB . mg5eyxlygw [ k ] + rtB . a3di22nq4d [ k ] ;
f0ngv3fxdj [ k ] = absxk ; } rtB . a5gud440br = ssGetT ( rtS ) ; if (
ssIsSampleHit ( rtS , 1 , 0 ) ) { if ( ssIsModeUpdateTimeStep ( rtS ) ) {
rtDW . fvuql44emp = ( rtB . a5gud440br >= rtP . detection_start ) ; } rtB .
mphsseyujn = rtDW . fvuql44emp ; } for ( i = 0 ; i < 61 ; i ++ ) { f0ngv3fxdj
[ i ] = rtB . mg5eyxlygw [ i ] * ( real_T ) rtB . mphsseyujn ; } { if ( rtDW
. bk4qjslljc . AQHandles && ssGetLogOutput ( rtS ) ) { sdiWriteSignal ( rtDW
. bk4qjslljc . AQHandles , ssGetTaskTime ( rtS , 0 ) , ( char * ) &
f0ngv3fxdj [ 0 ] + 0 ) ; } } for ( i = 0 ; i < 10 ; i ++ ) { dx4pk50v0m [ i ]
= rtB . mgua5brbul [ i ] * ( real_T ) rtB . mphsseyujn ; } { if ( rtDW .
dcrpxoznep . AQHandles && ssGetLogOutput ( rtS ) ) { sdiWriteSignal ( rtDW .
dcrpxoznep . AQHandles , ssGetTaskTime ( rtS , 0 ) , ( char * ) & dx4pk50v0m
[ 0 ] + 0 ) ; } } g01cj55nt3 = rtB . nty1qxc5vr * ( real_T ) rtB . mphsseyujn
; { if ( rtDW . ds0uokuev3 . AQHandles && ssGetLogOutput ( rtS ) ) {
sdiWriteSignal ( rtDW . ds0uokuev3 . AQHandles , ssGetTaskTime ( rtS , 0 ) ,
( char * ) & g01cj55nt3 + 0 ) ; } } for ( i = 0 ; i < 10 ; i ++ ) { rtB .
cb5s42cp3o [ i ] = rtX . leyzn45qrb [ i ] ; dx4pk50v0m [ i ] = rtB .
cb5s42cp3o [ i ] * ( real_T ) rtB . mphsseyujn ; } { if ( rtDW . mqwlltnsif .
AQHandles && ssGetLogOutput ( rtS ) ) { sdiWriteSignal ( rtDW . mqwlltnsif .
AQHandles , ssGetTaskTime ( rtS , 0 ) , ( char * ) & dx4pk50v0m [ 0 ] + 0 ) ;
} } rtB . mmuv5cxhlj = 0.0 ; g01cj55nt3 = 3.3121686421112381E-170 ; for ( k =
0 ; k < 61 ; k ++ ) { absxk = 0.0 ; for ( i = 0 ; i < 10 ; i ++ ) { absxk +=
rtP . C [ 61 * i + k ] * rtB . cb5s42cp3o [ i ] ; } absxk = muDoubleScalarAbs
( rtB . avbnkdzwhd [ k ] - absxk ) ; if ( absxk > g01cj55nt3 ) { t =
g01cj55nt3 / absxk ; rtB . mmuv5cxhlj = rtB . mmuv5cxhlj * t * t + 1.0 ;
g01cj55nt3 = absxk ; } else { t = absxk / g01cj55nt3 ; rtB . mmuv5cxhlj += t
* t ; } } rtB . mmuv5cxhlj = g01cj55nt3 * muDoubleScalarSqrt ( rtB .
mmuv5cxhlj ) ; g01cj55nt3 = rtB . mmuv5cxhlj * ( real_T ) rtB . mphsseyujn ;
{ if ( rtDW . ht0kegwtt4 . AQHandles && ssGetLogOutput ( rtS ) ) {
sdiWriteSignal ( rtDW . ht0kegwtt4 . AQHandles , ssGetTaskTime ( rtS , 0 ) ,
( char * ) & g01cj55nt3 + 0 ) ; } } for ( i = 0 ; i < 100 ; i ++ ) { tmp_p [
i ] = - rtP . K [ i ] ; } for ( i = 0 ; i < 10 ; i ++ ) { rtB . ojn1npo3a4 [
i ] = 0.0 ; dx4pk50v0m [ i ] = 0.0 ; for ( k = 0 ; k < 10 ; k ++ ) { rtB .
ojn1npo3a4 [ i ] += tmp_p [ 10 * k + i ] * rtB . cb5s42cp3o [ k ] ;
dx4pk50v0m [ i ] += rtP . A [ 10 * k + i ] * rtB . cb5s42cp3o [ k ] ; } tmp_e
[ i ] = 0.0 ; } for ( i = 0 ; i < 10 ; i ++ ) { for ( k = 0 ; k < 10 ; k ++ )
{ tmp_e [ i ] += rtP . B [ 10 * k + i ] * rtB . ojn1npo3a4 [ k ] ; } } for (
i = 0 ; i < 61 ; i ++ ) { absxk = 0.0 ; for ( k = 0 ; k < 10 ; k ++ ) { absxk
+= rtP . C [ 61 * k + i ] * rtB . cb5s42cp3o [ k ] ; } tmp [ i ] = rtB .
avbnkdzwhd [ i ] - absxk ; } for ( i = 0 ; i < 10 ; i ++ ) { absxk = 0.0 ;
for ( k = 0 ; k < 61 ; k ++ ) { absxk += rtP . L [ 10 * k + i ] * tmp [ k ] ;
} rtB . garaq0p5sy [ i ] = ( dx4pk50v0m [ i ] + tmp_e [ i ] ) + absxk ; tmp_i
[ i ] = 0.0 ; tmp_m [ i ] = 0.0 ; for ( k = 0 ; k < 10 ; k ++ ) { tmp_i [ i ]
+= rtP . A [ 10 * k + i ] * rtB . mgua5brbul [ k ] ; tmp_m [ i ] += rtP . B [
10 * k + i ] * rtB . ojn1npo3a4 [ k ] ; } rtB . gjagphk3li [ i ] = tmp_i [ i
] + tmp_m [ i ] ; } UNUSED_PARAMETER ( tid ) ; } void MdlOutputsTID3 ( int_T
tid ) { UNUSED_PARAMETER ( tid ) ; } void MdlUpdate ( int_T tid ) { if (
ssIsSampleHit ( rtS , 2 , 0 ) ) { rtDW . jflrz4f2zz = ( rtP .
UniformRandomNumber_Maximum - rtP . UniformRandomNumber_Minimum ) *
rt_urand_Upu32_Yd_f_pw_snf ( & rtDW . jircoqfdva ) + rtP .
UniformRandomNumber_Minimum ; } UNUSED_PARAMETER ( tid ) ; } void
MdlUpdateTID3 ( int_T tid ) { UNUSED_PARAMETER ( tid ) ; } void
MdlDerivatives ( void ) { XDot * _rtXdot ; _rtXdot = ( ( XDot * ) ssGetdX (
rtS ) ) ; memcpy ( & _rtXdot -> hyb3of0a4n [ 0 ] , & rtB . gjagphk3li [ 0 ] ,
10U * sizeof ( real_T ) ) ; memcpy ( & _rtXdot -> leyzn45qrb [ 0 ] , & rtB .
garaq0p5sy [ 0 ] , 10U * sizeof ( real_T ) ) ; } void MdlProjection ( void )
{ } void MdlZeroCrossings ( void ) { ZCV * _rtZCSV ; _rtZCSV = ( ( ZCV * )
ssGetSolverZcSignalVector ( rtS ) ) ; _rtZCSV -> fyn2dhfvj5 = rtB .
a5gud440br - rtP . detection_start ; } void MdlTerminate ( void ) { { if (
rtDW . bk4qjslljc . AQHandles ) { sdiTerminateStreaming ( & rtDW . bk4qjslljc
. AQHandles ) ; } } { if ( rtDW . dcrpxoznep . AQHandles ) {
sdiTerminateStreaming ( & rtDW . dcrpxoznep . AQHandles ) ; } } { if ( rtDW .
ds0uokuev3 . AQHandles ) { sdiTerminateStreaming ( & rtDW . ds0uokuev3 .
AQHandles ) ; } } { if ( rtDW . mqwlltnsif . AQHandles ) {
sdiTerminateStreaming ( & rtDW . mqwlltnsif . AQHandles ) ; } } { if ( rtDW .
ht0kegwtt4 . AQHandles ) { sdiTerminateStreaming ( & rtDW . ht0kegwtt4 .
AQHandles ) ; } } } static void mr_sample_system_cacheDataAsMxArray ( mxArray
* destArray , mwIndex i , int j , const void * srcData , size_t numBytes ) ;
static void mr_sample_system_cacheDataAsMxArray ( mxArray * destArray ,
mwIndex i , int j , const void * srcData , size_t numBytes ) { mxArray *
newArray = mxCreateUninitNumericMatrix ( ( size_t ) 1 , numBytes ,
mxUINT8_CLASS , mxREAL ) ; memcpy ( ( uint8_T * ) mxGetData ( newArray ) , (
const uint8_T * ) srcData , numBytes ) ; mxSetFieldByNumber ( destArray , i ,
j , newArray ) ; } static void mr_sample_system_restoreDataFromMxArray ( void
* destData , const mxArray * srcArray , mwIndex i , int j , size_t numBytes )
; static void mr_sample_system_restoreDataFromMxArray ( void * destData ,
const mxArray * srcArray , mwIndex i , int j , size_t numBytes ) { memcpy ( (
uint8_T * ) destData , ( const uint8_T * ) mxGetData ( mxGetFieldByNumber (
srcArray , i , j ) ) , numBytes ) ; } static void
mr_sample_system_cacheBitFieldToMxArray ( mxArray * destArray , mwIndex i ,
int j , uint_T bitVal ) ; static void mr_sample_system_cacheBitFieldToMxArray
( mxArray * destArray , mwIndex i , int j , uint_T bitVal ) {
mxSetFieldByNumber ( destArray , i , j , mxCreateDoubleScalar ( ( double )
bitVal ) ) ; } static uint_T mr_sample_system_extractBitFieldFromMxArray (
const mxArray * srcArray , mwIndex i , int j , uint_T numBits ) ; static
uint_T mr_sample_system_extractBitFieldFromMxArray ( const mxArray * srcArray
, mwIndex i , int j , uint_T numBits ) { const uint_T varVal = ( uint_T )
mxGetScalar ( mxGetFieldByNumber ( srcArray , i , j ) ) ; return varVal & ( (
1u << numBits ) - 1u ) ; } static void
mr_sample_system_cacheDataToMxArrayWithOffset ( mxArray * destArray , mwIndex
i , int j , mwIndex offset , const void * srcData , size_t numBytes ) ;
static void mr_sample_system_cacheDataToMxArrayWithOffset ( mxArray *
destArray , mwIndex i , int j , mwIndex offset , const void * srcData ,
size_t numBytes ) { uint8_T * varData = ( uint8_T * ) mxGetData (
mxGetFieldByNumber ( destArray , i , j ) ) ; memcpy ( ( uint8_T * ) & varData
[ offset * numBytes ] , ( const uint8_T * ) srcData , numBytes ) ; } static
void mr_sample_system_restoreDataFromMxArrayWithOffset ( void * destData ,
const mxArray * srcArray , mwIndex i , int j , mwIndex offset , size_t
numBytes ) ; static void mr_sample_system_restoreDataFromMxArrayWithOffset (
void * destData , const mxArray * srcArray , mwIndex i , int j , mwIndex
offset , size_t numBytes ) { const uint8_T * varData = ( const uint8_T * )
mxGetData ( mxGetFieldByNumber ( srcArray , i , j ) ) ; memcpy ( ( uint8_T *
) destData , ( const uint8_T * ) & varData [ offset * numBytes ] , numBytes )
; } static void mr_sample_system_cacheBitFieldToCellArrayWithOffset ( mxArray
* destArray , mwIndex i , int j , mwIndex offset , uint_T fieldVal ) ; static
void mr_sample_system_cacheBitFieldToCellArrayWithOffset ( mxArray *
destArray , mwIndex i , int j , mwIndex offset , uint_T fieldVal ) {
mxSetCell ( mxGetFieldByNumber ( destArray , i , j ) , offset ,
mxCreateDoubleScalar ( ( double ) fieldVal ) ) ; } static uint_T
mr_sample_system_extractBitFieldFromCellArrayWithOffset ( const mxArray *
srcArray , mwIndex i , int j , mwIndex offset , uint_T numBits ) ; static
uint_T mr_sample_system_extractBitFieldFromCellArrayWithOffset ( const
mxArray * srcArray , mwIndex i , int j , mwIndex offset , uint_T numBits ) {
const uint_T fieldVal = ( uint_T ) mxGetScalar ( mxGetCell (
mxGetFieldByNumber ( srcArray , i , j ) , offset ) ) ; return fieldVal & ( (
1u << numBits ) - 1u ) ; } mxArray * mr_sample_system_GetDWork ( ) { static
const char * ssDWFieldNames [ 3 ] = { "rtB" , "rtDW" , "NULL_PrevZCX" , } ;
mxArray * ssDW = mxCreateStructMatrix ( 1 , 1 , 3 , ssDWFieldNames ) ;
mr_sample_system_cacheDataAsMxArray ( ssDW , 0 , 0 , ( const void * ) & ( rtB
) , sizeof ( rtB ) ) ; { static const char * rtdwDataFieldNames [ 3 ] = {
"rtDW.jflrz4f2zz" , "rtDW.jircoqfdva" , "rtDW.fvuql44emp" , } ; mxArray *
rtdwData = mxCreateStructMatrix ( 1 , 1 , 3 , rtdwDataFieldNames ) ;
mr_sample_system_cacheDataAsMxArray ( rtdwData , 0 , 0 , ( const void * ) & (
rtDW . jflrz4f2zz ) , sizeof ( rtDW . jflrz4f2zz ) ) ;
mr_sample_system_cacheDataAsMxArray ( rtdwData , 0 , 1 , ( const void * ) & (
rtDW . jircoqfdva ) , sizeof ( rtDW . jircoqfdva ) ) ;
mr_sample_system_cacheDataAsMxArray ( rtdwData , 0 , 2 , ( const void * ) & (
rtDW . fvuql44emp ) , sizeof ( rtDW . fvuql44emp ) ) ; mxSetFieldByNumber (
ssDW , 0 , 1 , rtdwData ) ; } return ssDW ; } void mr_sample_system_SetDWork
( const mxArray * ssDW ) { ( void ) ssDW ;
mr_sample_system_restoreDataFromMxArray ( ( void * ) & ( rtB ) , ssDW , 0 , 0
, sizeof ( rtB ) ) ; { const mxArray * rtdwData = mxGetFieldByNumber ( ssDW ,
0 , 1 ) ; mr_sample_system_restoreDataFromMxArray ( ( void * ) & ( rtDW .
jflrz4f2zz ) , rtdwData , 0 , 0 , sizeof ( rtDW . jflrz4f2zz ) ) ;
mr_sample_system_restoreDataFromMxArray ( ( void * ) & ( rtDW . jircoqfdva )
, rtdwData , 0 , 1 , sizeof ( rtDW . jircoqfdva ) ) ;
mr_sample_system_restoreDataFromMxArray ( ( void * ) & ( rtDW . fvuql44emp )
, rtdwData , 0 , 2 , sizeof ( rtDW . fvuql44emp ) ) ; } } mxArray *
mr_sample_system_GetSimStateDisallowedBlocks ( ) { mxArray * data =
mxCreateCellMatrix ( 7 , 3 ) ; mwIndex subs [ 2 ] , offset ; { static const
char * blockType [ 7 ] = { "Scope" , "Scope" , "Scope" , "Scope" , "Scope" ,
"Scope" , "Scope" , } ; static const char * blockPath [ 7 ] = {
"sample_system/Scope" , "sample_system/attak_signal" ,
"sample_system/critical" , "sample_system/estimate" ,
"sample_system/measurements" , "sample_system/residual" ,
"sample_system/states" , } ; static const int reason [ 7 ] = { 0 , 0 , 0 , 0
, 0 , 0 , 0 , } ; for ( subs [ 0 ] = 0 ; subs [ 0 ] < 7 ; ++ ( subs [ 0 ] ) )
{ subs [ 1 ] = 0 ; offset = mxCalcSingleSubscript ( data , 2 , subs ) ;
mxSetCell ( data , offset , mxCreateString ( blockType [ subs [ 0 ] ] ) ) ;
subs [ 1 ] = 1 ; offset = mxCalcSingleSubscript ( data , 2 , subs ) ;
mxSetCell ( data , offset , mxCreateString ( blockPath [ subs [ 0 ] ] ) ) ;
subs [ 1 ] = 2 ; offset = mxCalcSingleSubscript ( data , 2 , subs ) ;
mxSetCell ( data , offset , mxCreateDoubleScalar ( ( double ) reason [ subs [
0 ] ] ) ) ; } } return data ; } void MdlInitializeSizes ( void ) {
ssSetNumContStates ( rtS , 20 ) ; ssSetNumPeriodicContStates ( rtS , 0 ) ;
ssSetNumY ( rtS , 0 ) ; ssSetNumU ( rtS , 0 ) ; ssSetDirectFeedThrough ( rtS
, 0 ) ; ssSetNumSampleTimes ( rtS , 3 ) ; ssSetNumBlocks ( rtS , 44 ) ;
ssSetNumBlockIO ( rtS , 15 ) ; ssSetNumBlockParams ( rtS , 1738 ) ; } void
MdlInitializeSampleTimes ( void ) { ssSetSampleTime ( rtS , 0 , 0.0 ) ;
ssSetSampleTime ( rtS , 1 , 0.0 ) ; ssSetSampleTime ( rtS , 2 , 0.01 ) ;
ssSetOffsetTime ( rtS , 0 , 0.0 ) ; ssSetOffsetTime ( rtS , 1 , 1.0 ) ;
ssSetOffsetTime ( rtS , 2 , 0.0 ) ; } void raccel_set_checksum ( ) {
ssSetChecksumVal ( rtS , 0 , 2693835777U ) ; ssSetChecksumVal ( rtS , 1 ,
872802496U ) ; ssSetChecksumVal ( rtS , 2 , 4133713670U ) ; ssSetChecksumVal
( rtS , 3 , 3670903414U ) ; }
#if defined(_MSC_VER)
#pragma optimize( "", off )
#endif
SimStruct * raccel_register_model ( ssExecutionInfo * executionInfo ) {
static struct _ssMdlInfo mdlInfo ; static struct _ssBlkInfo2 blkInfo2 ;
static struct _ssBlkInfoSLSize blkInfoSLSize ; ( void ) memset ( ( char * )
rtS , 0 , sizeof ( SimStruct ) ) ; ( void ) memset ( ( char * ) & mdlInfo , 0
, sizeof ( struct _ssMdlInfo ) ) ; ( void ) memset ( ( char * ) & blkInfo2 ,
0 , sizeof ( struct _ssBlkInfo2 ) ) ; ( void ) memset ( ( char * ) &
blkInfoSLSize , 0 , sizeof ( struct _ssBlkInfoSLSize ) ) ; ssSetBlkInfo2Ptr (
rtS , & blkInfo2 ) ; ssSetBlkInfoSLSizePtr ( rtS , & blkInfoSLSize ) ;
ssSetMdlInfoPtr ( rtS , & mdlInfo ) ; ssSetExecutionInfo ( rtS ,
executionInfo ) ; slsaAllocOPModelData ( rtS ) ; { static time_T mdlPeriod [
NSAMPLE_TIMES ] ; static time_T mdlOffset [ NSAMPLE_TIMES ] ; static time_T
mdlTaskTimes [ NSAMPLE_TIMES ] ; static int_T mdlTsMap [ NSAMPLE_TIMES ] ;
static int_T mdlSampleHits [ NSAMPLE_TIMES ] ; static boolean_T
mdlTNextWasAdjustedPtr [ NSAMPLE_TIMES ] ; static int_T mdlPerTaskSampleHits
[ NSAMPLE_TIMES * NSAMPLE_TIMES ] ; static time_T mdlTimeOfNextSampleHit [
NSAMPLE_TIMES ] ; { int_T i ; for ( i = 0 ; i < NSAMPLE_TIMES ; i ++ ) {
mdlPeriod [ i ] = 0.0 ; mdlOffset [ i ] = 0.0 ; mdlTaskTimes [ i ] = 0.0 ;
mdlTsMap [ i ] = i ; mdlSampleHits [ i ] = 1 ; } } ssSetSampleTimePtr ( rtS ,
& mdlPeriod [ 0 ] ) ; ssSetOffsetTimePtr ( rtS , & mdlOffset [ 0 ] ) ;
ssSetSampleTimeTaskIDPtr ( rtS , & mdlTsMap [ 0 ] ) ; ssSetTPtr ( rtS , &
mdlTaskTimes [ 0 ] ) ; ssSetSampleHitPtr ( rtS , & mdlSampleHits [ 0 ] ) ;
ssSetTNextWasAdjustedPtr ( rtS , & mdlTNextWasAdjustedPtr [ 0 ] ) ;
ssSetPerTaskSampleHitsPtr ( rtS , & mdlPerTaskSampleHits [ 0 ] ) ;
ssSetTimeOfNextSampleHitPtr ( rtS , & mdlTimeOfNextSampleHit [ 0 ] ) ; }
ssSetSolverMode ( rtS , SOLVER_MODE_SINGLETASKING ) ; { ssSetBlockIO ( rtS ,
( ( void * ) & rtB ) ) ; ( void ) memset ( ( ( void * ) & rtB ) , 0 , sizeof
( B ) ) ; } { real_T * x = ( real_T * ) & rtX ; ssSetContStates ( rtS , x ) ;
( void ) memset ( ( void * ) x , 0 , sizeof ( X ) ) ; } { void * dwork = (
void * ) & rtDW ; ssSetRootDWork ( rtS , dwork ) ; ( void ) memset ( dwork ,
0 , sizeof ( DW ) ) ; } { static DataTypeTransInfo dtInfo ; ( void ) memset (
( char_T * ) & dtInfo , 0 , sizeof ( dtInfo ) ) ; ssSetModelMappingInfo ( rtS
, & dtInfo ) ; dtInfo . numDataTypes = 22 ; dtInfo . dataTypeSizes = &
rtDataTypeSizes [ 0 ] ; dtInfo . dataTypeNames = & rtDataTypeNames [ 0 ] ;
dtInfo . BTransTable = & rtBTransTable ; dtInfo . PTransTable = &
rtPTransTable ; dtInfo . dataTypeInfoTable = rtDataTypeInfoTable ; }
sample_system_InitializeDataMapInfo ( ) ; ssSetIsRapidAcceleratorActive ( rtS
, true ) ; ssSetRootSS ( rtS , rtS ) ; ssSetVersion ( rtS ,
SIMSTRUCT_VERSION_LEVEL2 ) ; ssSetModelName ( rtS , "sample_system" ) ;
ssSetPath ( rtS , "sample_system" ) ; ssSetTStart ( rtS , 0.0 ) ; ssSetTFinal
( rtS , 10.0 ) ; { static RTWLogInfo rt_DataLoggingInfo ; rt_DataLoggingInfo
. loggingInterval = ( NULL ) ; ssSetRTWLogInfo ( rtS , & rt_DataLoggingInfo )
; } { { static int_T rt_LoggedStateWidths [ ] = { 10 , 10 } ; static int_T
rt_LoggedStateNumDimensions [ ] = { 1 , 1 } ; static int_T
rt_LoggedStateDimensions [ ] = { 10 , 10 } ; static boolean_T
rt_LoggedStateIsVarDims [ ] = { 0 , 0 } ; static BuiltInDTypeId
rt_LoggedStateDataTypeIds [ ] = { SS_DOUBLE , SS_DOUBLE } ; static int_T
rt_LoggedStateComplexSignals [ ] = { 0 , 0 } ; static RTWPreprocessingFcnPtr
rt_LoggingStatePreprocessingFcnPtrs [ ] = { ( NULL ) , ( NULL ) } ; static
const char_T * rt_LoggedStateLabels [ ] = { "CSTATE" , "CSTATE" } ; static
const char_T * rt_LoggedStateBlockNames [ ] = { "sample_system/Integrator" ,
"sample_system/Integrator1" } ; static const char_T * rt_LoggedStateNames [ ]
= { "" , "" } ; static boolean_T rt_LoggedStateCrossMdlRef [ ] = { 0 , 0 } ;
static RTWLogDataTypeConvert rt_RTWLogDataTypeConvert [ ] = { { 0 , SS_DOUBLE
, SS_DOUBLE , 0 , 0 , 0 , 1.0 , 0 , 0.0 } , { 0 , SS_DOUBLE , SS_DOUBLE , 0 ,
0 , 0 , 1.0 , 0 , 0.0 } } ; static int_T rt_LoggedStateIdxList [ ] = { 0 , 1
} ; static RTWLogSignalInfo rt_LoggedStateSignalInfo = { 2 ,
rt_LoggedStateWidths , rt_LoggedStateNumDimensions , rt_LoggedStateDimensions
, rt_LoggedStateIsVarDims , ( NULL ) , ( NULL ) , rt_LoggedStateDataTypeIds ,
rt_LoggedStateComplexSignals , ( NULL ) , rt_LoggingStatePreprocessingFcnPtrs
, { rt_LoggedStateLabels } , ( NULL ) , ( NULL ) , ( NULL ) , {
rt_LoggedStateBlockNames } , { rt_LoggedStateNames } ,
rt_LoggedStateCrossMdlRef , rt_RTWLogDataTypeConvert , rt_LoggedStateIdxList
} ; static void * rt_LoggedStateSignalPtrs [ 2 ] ; rtliSetLogXSignalPtrs (
ssGetRTWLogInfo ( rtS ) , ( LogSignalPtrsType ) rt_LoggedStateSignalPtrs ) ;
rtliSetLogXSignalInfo ( ssGetRTWLogInfo ( rtS ) , & rt_LoggedStateSignalInfo
) ; rt_LoggedStateSignalPtrs [ 0 ] = ( void * ) & rtX . hyb3of0a4n [ 0 ] ;
rt_LoggedStateSignalPtrs [ 1 ] = ( void * ) & rtX . leyzn45qrb [ 0 ] ; }
rtliSetLogT ( ssGetRTWLogInfo ( rtS ) , "tout" ) ; rtliSetLogX (
ssGetRTWLogInfo ( rtS ) , "" ) ; rtliSetLogXFinal ( ssGetRTWLogInfo ( rtS ) ,
"xFinal" ) ; rtliSetLogVarNameModifier ( ssGetRTWLogInfo ( rtS ) , "none" ) ;
rtliSetLogFormat ( ssGetRTWLogInfo ( rtS ) , 4 ) ; rtliSetLogMaxRows (
ssGetRTWLogInfo ( rtS ) , 0 ) ; rtliSetLogDecimation ( ssGetRTWLogInfo ( rtS
) , 1 ) ; rtliSetLogY ( ssGetRTWLogInfo ( rtS ) , "" ) ;
rtliSetLogYSignalInfo ( ssGetRTWLogInfo ( rtS ) , ( NULL ) ) ;
rtliSetLogYSignalPtrs ( ssGetRTWLogInfo ( rtS ) , ( NULL ) ) ; } { static
struct _ssStatesInfo2 statesInfo2 ; ssSetStatesInfo2 ( rtS , & statesInfo2 )
; } { static ssPeriodicStatesInfo periodicStatesInfo ;
ssSetPeriodicStatesInfo ( rtS , & periodicStatesInfo ) ; } { static
ssJacobianPerturbationBounds jacobianPerturbationBounds ;
ssSetJacobianPerturbationBounds ( rtS , & jacobianPerturbationBounds ) ; } {
static ssSolverInfo slvrInfo ; static boolean_T contStatesDisabled [ 20 ] ;
static real_T absTol [ 20 ] = { 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 ,
1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 , 1.0E-6 } ; static
uint8_T absTolControl [ 20 ] = { 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U ,
0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U , 0U } ; static real_T
contStateJacPerturbBoundMinVec [ 20 ] ; static real_T
contStateJacPerturbBoundMaxVec [ 20 ] ; static uint8_T zcAttributes [ 1 ] = {
( ZC_EVENT_ALL ) } ; static ssNonContDerivSigInfo nonContDerivSigInfo [ 1 ] =
{ { 1 * sizeof ( real_T ) , ( char * ) ( & rtB . m2hykcpgz2 ) , ( NULL ) } }
; { int i ; for ( i = 0 ; i < 20 ; ++ i ) { contStateJacPerturbBoundMinVec [
i ] = 0 ; contStateJacPerturbBoundMaxVec [ i ] = rtGetInf ( ) ; } }
ssSetSolverRelTol ( rtS , 0.001 ) ; ssSetStepSize ( rtS , 0.0 ) ;
ssSetMinStepSize ( rtS , 0.0 ) ; ssSetMaxNumMinSteps ( rtS , - 1 ) ;
ssSetMinStepViolatedError ( rtS , 0 ) ; ssSetMaxStepSize ( rtS , 0.01 ) ;
ssSetSolverMaxOrder ( rtS , - 1 ) ; ssSetSolverRefineFactor ( rtS , 1 ) ;
ssSetOutputTimes ( rtS , ( NULL ) ) ; ssSetNumOutputTimes ( rtS , 0 ) ;
ssSetOutputTimesOnly ( rtS , 0 ) ; ssSetOutputTimesIndex ( rtS , 0 ) ;
ssSetZCCacheNeedsReset ( rtS , 0 ) ; ssSetDerivCacheNeedsReset ( rtS , 0 ) ;
ssSetNumNonContDerivSigInfos ( rtS , 1 ) ; ssSetNonContDerivSigInfos ( rtS ,
nonContDerivSigInfo ) ; ssSetSolverInfo ( rtS , & slvrInfo ) ;
ssSetSolverName ( rtS , "VariableStepAuto" ) ; ssSetVariableStepSolver ( rtS
, 1 ) ; ssSetSolverConsistencyChecking ( rtS , 0 ) ;
ssSetSolverAdaptiveZcDetection ( rtS , 0 ) ; ssSetSolverRobustResetMethod (
rtS , 0 ) ; ssSetAbsTolVector ( rtS , absTol ) ; ssSetAbsTolControlVector (
rtS , absTolControl ) ; ssSetSolverAbsTol_Obsolete ( rtS , absTol ) ;
ssSetSolverAbsTolControl_Obsolete ( rtS , absTolControl ) ;
ssSetJacobianPerturbationBoundsMinVec ( rtS , contStateJacPerturbBoundMinVec
) ; ssSetJacobianPerturbationBoundsMaxVec ( rtS ,
contStateJacPerturbBoundMaxVec ) ; ssSetSolverStateProjection ( rtS , 0 ) ;
ssSetSolverMassMatrixType ( rtS , ( ssMatrixType ) 0 ) ;
ssSetSolverMassMatrixNzMax ( rtS , 0 ) ; ssSetModelOutputs ( rtS , MdlOutputs
) ; ssSetModelLogData ( rtS , rt_UpdateTXYLogVars ) ;
ssSetModelLogDataIfInInterval ( rtS , rt_UpdateTXXFYLogVars ) ;
ssSetModelUpdate ( rtS , MdlUpdate ) ; ssSetModelDerivatives ( rtS ,
MdlDerivatives ) ; ssSetSolverZcSignalAttrib ( rtS , zcAttributes ) ;
ssSetSolverNumZcSignals ( rtS , 1 ) ; ssSetModelZeroCrossings ( rtS ,
MdlZeroCrossings ) ; ssSetSolverConsecutiveZCsStepRelTol ( rtS ,
2.8421709430404007E-13 ) ; ssSetSolverMaxConsecutiveZCs ( rtS , 1000 ) ;
ssSetSolverConsecutiveZCsError ( rtS , 2 ) ; ssSetSolverMaskedZcDiagnostic (
rtS , 1 ) ; ssSetSolverIgnoredZcDiagnostic ( rtS , 1 ) ;
ssSetSolverMaxConsecutiveMinStep ( rtS , 1 ) ;
ssSetSolverShapePreserveControl ( rtS , 2 ) ; ssSetTNextTid ( rtS , INT_MIN )
; ssSetTNext ( rtS , rtMinusInf ) ; ssSetSolverNeedsReset ( rtS ) ;
ssSetNumNonsampledZCs ( rtS , 1 ) ; ssSetContStateDisabled ( rtS ,
contStatesDisabled ) ; ssSetSolverMaxConsecutiveMinStep ( rtS , 1 ) ; }
ssSetChecksumVal ( rtS , 0 , 2693835777U ) ; ssSetChecksumVal ( rtS , 1 ,
872802496U ) ; ssSetChecksumVal ( rtS , 2 , 4133713670U ) ; ssSetChecksumVal
( rtS , 3 , 3670903414U ) ; { static const sysRanDType rtAlwaysEnabled =
SUBSYS_RAN_BC_ENABLE ; static RTWExtModeInfo rt_ExtModeInfo ; static const
sysRanDType * systemRan [ 6 ] ; gblRTWExtModeInfo = & rt_ExtModeInfo ;
ssSetRTWExtModeInfo ( rtS , & rt_ExtModeInfo ) ;
rteiSetSubSystemActiveVectorAddresses ( & rt_ExtModeInfo , systemRan ) ;
systemRan [ 0 ] = & rtAlwaysEnabled ; systemRan [ 1 ] = & rtAlwaysEnabled ;
systemRan [ 2 ] = & rtAlwaysEnabled ; systemRan [ 3 ] = & rtAlwaysEnabled ;
systemRan [ 4 ] = & rtAlwaysEnabled ; systemRan [ 5 ] = & rtAlwaysEnabled ;
rteiSetModelMappingInfoPtr ( ssGetRTWExtModeInfo ( rtS ) , &
ssGetModelMappingInfo ( rtS ) ) ; rteiSetChecksumsPtr ( ssGetRTWExtModeInfo (
rtS ) , ssGetChecksums ( rtS ) ) ; rteiSetTPtr ( ssGetRTWExtModeInfo ( rtS )
, ssGetTPtr ( rtS ) ) ; } slsaDisallowedBlocksForSimTargetOP ( rtS ,
mr_sample_system_GetSimStateDisallowedBlocks ) ; slsaGetWorkFcnForSimTargetOP
( rtS , mr_sample_system_GetDWork ) ; slsaSetWorkFcnForSimTargetOP ( rtS ,
mr_sample_system_SetDWork ) ; rt_RapidReadMatFileAndUpdateParams ( rtS ) ; if
( ssGetErrorStatus ( rtS ) ) { return rtS ; } return rtS ; }
#if defined(_MSC_VER)
#pragma optimize( "", on )
#endif
const int_T gblParameterTuningTid = 3 ; void MdlOutputsParameterSampleTime (
int_T tid ) { MdlOutputsTID3 ( tid ) ; }
