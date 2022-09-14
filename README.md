# REDCS

## System Setup
![image](https://user-images.githubusercontent.com/36635562/189228816-7d4a9958-572a-47a3-b1d5-d6b247a56d4d.png)

## Nominal Control perfromance
- qr = 10
- gamma = 0.1

The nominal result shows q1, q4 are both in side 9~11
![image](https://user-images.githubusercontent.com/36635562/189228878-6ed44c0b-05ac-473e-998d-39dad19130b9.png)

## Generator training performance
- generator probability loss function: relu(sum(e^f1)-eta) + relu(sum(e^f2)-eta), where f1 = stealth - stealth_thresh, f2 = effect_thresh - effect 

![image](https://user-images.githubusercontent.com/72170474/190227950-486f2214-cc93-43f3-9246-c0550063ac15.png)

- generator indicator loss function: relu(mean(f1)) + relu(mean(f2))

![image](https://user-images.githubusercontent.com/72170474/190228640-ff6e60de-7d63-4628-8adf-7d6a15b9701a.png)

![image](https://user-images.githubusercontent.com/72170474/190228728-2b21dd22-8208-48a2-8a90-7fa69c406cb5.png)
