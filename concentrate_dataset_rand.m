clear all

local_var_rand1 = load('random_attack_data_full.mat');
sim_obj1       = local_var_rand1.sim_obj;
Z_attack_data1 = local_var_rand1.Z_attack_data;
effect_index1  = local_var_rand1.effect_index;
stealth_index1 = local_var_rand1.stealth_index;

local_var_rand2 = load('random_attack_data_middle.mat');
sim_obj2       = local_var_rand2.sim_obj;
Z_attack_data2 = local_var_rand2.Z_attack_data;
effect_index2  = local_var_rand2.effect_index;
stealth_index2 = local_var_rand2.stealth_index;

local_var_rand3 = load('random_attack_data_big.mat');
sim_obj3       = local_var_rand3.sim_obj;
Z_attack_data3 = local_var_rand3.Z_attack_data;
effect_index3  = local_var_rand3.effect_index;
stealth_index3 = local_var_rand3.stealth_index;

local_var_rand4 = load('random_attack_data_small.mat');
sim_obj4       = local_var_rand4.sim_obj;
Z_attack_data4 = local_var_rand4.Z_attack_data;
effect_index4  = local_var_rand4.effect_index;
stealth_index4 = local_var_rand4.stealth_index;

local_var_rand5 = load('random_attack_data_verysmall.mat');
sim_obj5       = local_var_rand5.sim_obj;
Z_attack_data5 = local_var_rand5.Z_attack_data;
effect_index5  = local_var_rand5.effect_index;
stealth_index5 = local_var_rand5.stealth_index;

sim_obj = [sim_obj1;sim_obj2;sim_obj3;sim_obj4;sim_obj5];
Z_attack_data = [Z_attack_data1,Z_attack_data2,Z_attack_data3,Z_attack_data4,Z_attack_data5];
effect_index = [effect_index1;effect_index2;effect_index3;effect_index4;effect_index5];
stealth_index = [stealth_index1;stealth_index2;stealth_index3;stealth_index4;stealth_index5];

save('random_attack_data','sim_obj','effect_index','stealth_index','Z_attack_data','-v7.3');