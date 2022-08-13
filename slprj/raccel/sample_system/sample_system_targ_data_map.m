    function targMap = targDataMap(),

    ;%***********************
    ;% Create Parameter Map *
    ;%***********************
    
        nTotData      = 0; %add to this count as we go
        nTotSects     = 1;
        sectIdxOffset = 0;

        ;%
        ;% Define dummy sections & preallocate arrays
        ;%
        dumSection.nData = -1;
        dumSection.data  = [];

        dumData.logicalSrcIdx = -1;
        dumData.dtTransOffset = -1;

        ;%
        ;% Init/prealloc paramMap
        ;%
        paramMap.nSections           = nTotSects;
        paramMap.sectIdxOffset       = sectIdxOffset;
            paramMap.sections(nTotSects) = dumSection; %prealloc
        paramMap.nTotData            = -1;

        ;%
        ;% Auto data (rtP)
        ;%
            section.nData     = 16;
            section.data(16)  = dumData; %prealloc

                    ;% rtP.A
                    section.data(1).logicalSrcIdx = 0;
                    section.data(1).dtTransOffset = 0;

                    ;% rtP.B
                    section.data(2).logicalSrcIdx = 1;
                    section.data(2).dtTransOffset = 100;

                    ;% rtP.C
                    section.data(3).logicalSrcIdx = 2;
                    section.data(3).dtTransOffset = 200;

                    ;% rtP.Cc
                    section.data(4).logicalSrcIdx = 3;
                    section.data(4).dtTransOffset = 810;

                    ;% rtP.K
                    section.data(5).logicalSrcIdx = 4;
                    section.data(5).dtTransOffset = 820;

                    ;% rtP.L
                    section.data(6).logicalSrcIdx = 5;
                    section.data(6).dtTransOffset = 920;

                    ;% rtP.attack_final_deviations
                    section.data(7).logicalSrcIdx = 6;
                    section.data(7).dtTransOffset = 1530;

                    ;% rtP.attack_full_times
                    section.data(8).logicalSrcIdx = 7;
                    section.data(8).dtTransOffset = 1591;

                    ;% rtP.attack_start_times
                    section.data(9).logicalSrcIdx = 8;
                    section.data(9).dtTransOffset = 1652;

                    ;% rtP.detection_start
                    section.data(10).logicalSrcIdx = 9;
                    section.data(10).dtTransOffset = 1713;

                    ;% rtP.noise_seed
                    section.data(11).logicalSrcIdx = 10;
                    section.data(11).dtTransOffset = 1714;

                    ;% rtP.noise_trigger
                    section.data(12).logicalSrcIdx = 11;
                    section.data(12).dtTransOffset = 1715;

                    ;% rtP.x0
                    section.data(13).logicalSrcIdx = 12;
                    section.data(13).dtTransOffset = 1716;

                    ;% rtP.x_hat0
                    section.data(14).logicalSrcIdx = 13;
                    section.data(14).dtTransOffset = 1726;

                    ;% rtP.UniformRandomNumber_Minimum
                    section.data(15).logicalSrcIdx = 14;
                    section.data(15).dtTransOffset = 1736;

                    ;% rtP.UniformRandomNumber_Maximum
                    section.data(16).logicalSrcIdx = 15;
                    section.data(16).dtTransOffset = 1737;

            nTotData = nTotData + section.nData;
            paramMap.sections(1) = section;
            clear section


            ;%
            ;% Non-auto Data (parameter)
            ;%


        ;%
        ;% Add final counts to struct.
        ;%
        paramMap.nTotData = nTotData;



    ;%**************************
    ;% Create Block Output Map *
    ;%**************************
    
        nTotData      = 0; %add to this count as we go
        nTotSects     = 2;
        sectIdxOffset = 0;

        ;%
        ;% Define dummy sections & preallocate arrays
        ;%
        dumSection.nData = -1;
        dumSection.data  = [];

        dumData.logicalSrcIdx = -1;
        dumData.dtTransOffset = -1;

        ;%
        ;% Init/prealloc sigMap
        ;%
        sigMap.nSections           = nTotSects;
        sigMap.sectIdxOffset       = sectIdxOffset;
            sigMap.sections(nTotSects) = dumSection; %prealloc
        sigMap.nTotData            = -1;

        ;%
        ;% Auto data (rtB)
        ;%
            section.nData     = 14;
            section.data(14)  = dumData; %prealloc

                    ;% rtB.m2hykcpgz2
                    section.data(1).logicalSrcIdx = 0;
                    section.data(1).dtTransOffset = 0;

                    ;% rtB.mgua5brbul
                    section.data(2).logicalSrcIdx = 1;
                    section.data(2).dtTransOffset = 1;

                    ;% rtB.lsafowoqzm
                    section.data(3).logicalSrcIdx = 2;
                    section.data(3).dtTransOffset = 11;

                    ;% rtB.mg5eyxlygw
                    section.data(4).logicalSrcIdx = 3;
                    section.data(4).dtTransOffset = 72;

                    ;% rtB.a3di22nq4d
                    section.data(5).logicalSrcIdx = 4;
                    section.data(5).dtTransOffset = 133;

                    ;% rtB.avbnkdzwhd
                    section.data(6).logicalSrcIdx = 5;
                    section.data(6).dtTransOffset = 194;

                    ;% rtB.a5gud440br
                    section.data(7).logicalSrcIdx = 6;
                    section.data(7).dtTransOffset = 255;

                    ;% rtB.cb5s42cp3o
                    section.data(8).logicalSrcIdx = 7;
                    section.data(8).dtTransOffset = 256;

                    ;% rtB.ojn1npo3a4
                    section.data(9).logicalSrcIdx = 8;
                    section.data(9).dtTransOffset = 266;

                    ;% rtB.nty1qxc5vr
                    section.data(10).logicalSrcIdx = 9;
                    section.data(10).dtTransOffset = 276;

                    ;% rtB.gjagphk3li
                    section.data(11).logicalSrcIdx = 10;
                    section.data(11).dtTransOffset = 277;

                    ;% rtB.mmuv5cxhlj
                    section.data(12).logicalSrcIdx = 11;
                    section.data(12).dtTransOffset = 287;

                    ;% rtB.garaq0p5sy
                    section.data(13).logicalSrcIdx = 12;
                    section.data(13).dtTransOffset = 288;

                    ;% rtB.bhepmgnidu
                    section.data(14).logicalSrcIdx = 13;
                    section.data(14).dtTransOffset = 298;

            nTotData = nTotData + section.nData;
            sigMap.sections(1) = section;
            clear section

            section.nData     = 1;
            section.data(1)  = dumData; %prealloc

                    ;% rtB.mphsseyujn
                    section.data(1).logicalSrcIdx = 14;
                    section.data(1).dtTransOffset = 0;

            nTotData = nTotData + section.nData;
            sigMap.sections(2) = section;
            clear section


            ;%
            ;% Non-auto Data (signal)
            ;%


        ;%
        ;% Add final counts to struct.
        ;%
        sigMap.nTotData = nTotData;



    ;%*******************
    ;% Create DWork Map *
    ;%*******************
    
        nTotData      = 0; %add to this count as we go
        nTotSects     = 4;
        sectIdxOffset = 2;

        ;%
        ;% Define dummy sections & preallocate arrays
        ;%
        dumSection.nData = -1;
        dumSection.data  = [];

        dumData.logicalSrcIdx = -1;
        dumData.dtTransOffset = -1;

        ;%
        ;% Init/prealloc dworkMap
        ;%
        dworkMap.nSections           = nTotSects;
        dworkMap.sectIdxOffset       = sectIdxOffset;
            dworkMap.sections(nTotSects) = dumSection; %prealloc
        dworkMap.nTotData            = -1;

        ;%
        ;% Auto data (rtDW)
        ;%
            section.nData     = 1;
            section.data(1)  = dumData; %prealloc

                    ;% rtDW.jflrz4f2zz
                    section.data(1).logicalSrcIdx = 0;
                    section.data(1).dtTransOffset = 0;

            nTotData = nTotData + section.nData;
            dworkMap.sections(1) = section;
            clear section

            section.nData     = 12;
            section.data(12)  = dumData; %prealloc

                    ;% rtDW.ecs1y5aje0.LoggedData
                    section.data(1).logicalSrcIdx = 1;
                    section.data(1).dtTransOffset = 0;

                    ;% rtDW.bk4qjslljc.AQHandles
                    section.data(2).logicalSrcIdx = 2;
                    section.data(2).dtTransOffset = 1;

                    ;% rtDW.dcrpxoznep.AQHandles
                    section.data(3).logicalSrcIdx = 3;
                    section.data(3).dtTransOffset = 2;

                    ;% rtDW.ds0uokuev3.AQHandles
                    section.data(4).logicalSrcIdx = 4;
                    section.data(4).dtTransOffset = 3;

                    ;% rtDW.mqwlltnsif.AQHandles
                    section.data(5).logicalSrcIdx = 5;
                    section.data(5).dtTransOffset = 4;

                    ;% rtDW.ht0kegwtt4.AQHandles
                    section.data(6).logicalSrcIdx = 6;
                    section.data(6).dtTransOffset = 5;

                    ;% rtDW.os2t0qr0ej.LoggedData
                    section.data(7).logicalSrcIdx = 7;
                    section.data(7).dtTransOffset = 6;

                    ;% rtDW.ksiml4nejt.LoggedData
                    section.data(8).logicalSrcIdx = 8;
                    section.data(8).dtTransOffset = 7;

                    ;% rtDW.johdteycds.LoggedData
                    section.data(9).logicalSrcIdx = 9;
                    section.data(9).dtTransOffset = 8;

                    ;% rtDW.pyr3adjohh.LoggedData
                    section.data(10).logicalSrcIdx = 10;
                    section.data(10).dtTransOffset = 9;

                    ;% rtDW.jhwuxhzmgd.LoggedData
                    section.data(11).logicalSrcIdx = 11;
                    section.data(11).dtTransOffset = 10;

                    ;% rtDW.l1uxu5bmue.LoggedData
                    section.data(12).logicalSrcIdx = 12;
                    section.data(12).dtTransOffset = 11;

            nTotData = nTotData + section.nData;
            dworkMap.sections(2) = section;
            clear section

            section.nData     = 1;
            section.data(1)  = dumData; %prealloc

                    ;% rtDW.jircoqfdva
                    section.data(1).logicalSrcIdx = 13;
                    section.data(1).dtTransOffset = 0;

            nTotData = nTotData + section.nData;
            dworkMap.sections(3) = section;
            clear section

            section.nData     = 1;
            section.data(1)  = dumData; %prealloc

                    ;% rtDW.fvuql44emp
                    section.data(1).logicalSrcIdx = 14;
                    section.data(1).dtTransOffset = 0;

            nTotData = nTotData + section.nData;
            dworkMap.sections(4) = section;
            clear section


            ;%
            ;% Non-auto Data (dwork)
            ;%


        ;%
        ;% Add final counts to struct.
        ;%
        dworkMap.nTotData = nTotData;



    ;%
    ;% Add individual maps to base struct.
    ;%

    targMap.paramMap  = paramMap;
    targMap.signalMap = sigMap;
    targMap.dworkMap  = dworkMap;

    ;%
    ;% Add checksums to base struct.
    ;%


    targMap.checksum0 = 3479393406;
    targMap.checksum1 = 2832823330;
    targMap.checksum2 = 194449782;
    targMap.checksum3 = 1295974402;

