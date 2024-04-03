# VSCode setup pre ROS2 C++ programovanie

Návod predpokladá, že máte nainštalovaný ROS2 Foxy podľa https://github.com/stecf/uds_kobuki_ros. 

Vysoko odporúčam, aby ste si svoj **ros_ws** vytvorili na takom umiestnení a s takým názvom, ktoré neobsahuje medzery, ani žiadne špeciálne znaky. Vývojové nástroje majú bežne problém pracovať s takýmito cestami. 

## Inštalácia a spúšťanie VSCode

Všeobecne odporúčam inštalovať systémový variant VSCode (na stránke VSCode pomenovaný **System Installer**), ktorý sa inštaluje do systémových priečinkov (Program Files) nie do užívateľských priečinkov (%AppData%). **Link na stiahnutie System Installeru**: https://code.visualstudio.com/docs/?dv=win64.

Tiež všeobecne odporúčam VSCode spúšťať z konzoli v ktorej bol sourcnutý ROS2. Toto môžete spraviť príkazom:

```bash
code
```
Alebo si môžete vyrobiť skript založený na mojich sourcovacích skriptoch

```bat
@echo off

rem Initialize console with Visual Studio environment and source ROS2
call %~dp0\ros2init.bat 
rem Run VSCode
call code
```

## VSCode Extensions

Pre programovanie, buildovanie a debug ROS2 C++ sú odporúčané nasledovné rozšírenia:

- [ROS](https://marketplace.visualstudio.com/items?itemName=ms-iot.vscode-ros) with Dependacies:
    - [Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
    - [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)
- [C/C++ Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools-extension-pack)
- [CMake](https://marketplace.visualstudio.com/items?itemName=twxs.cmake) (Optional)

## [Otvorenie projektu / workspace](https://picknik.ai/vscode/docker/ros2/2024/01/23/ROS2-and-VSCode.html)

Projekt / workspace stačí otvoriť ako **"Open Folder"** v koreni workspace. Štandardne má workspace priečinok sufix **"_ws"**, práve tento priečinok je potrebné otvoriť.

Ak chcete používať integrovanú konzolu VSCode na spúšťanie ROS2 príkazov upravte svoj **settings.json**, ktorý sa nachádza v **%AppData%\\Roaming\\Code\\User\\settings.json**. Do *"terminal.integrated.profiles.windows":* môžete pridať **profil ros2cmd**:
```json
"ros2cmd": {
    "path": [
        "${env:windir}\\Sysnative\\cmd.exe",
        "${env:windir}\\System32\\cmd.exe"
    ],
    "args": [
        "/d",
        "/k", 
        "C:\\ros2\\ros2console"] // Toto je môj sourcovací skript, môžete namiesto tohto použiť priamo príkaz "source ros2...." 
}
```

## [Colcon Build vo VSCode](https://picknik.ai/vscode/docker/ros2/2024/01/23/ROS2-and-VSCode.html)

Po nainštalovaní rozšírenia ROS by mal byť automaticky vytvorený task, na buildovanie ROS package-ov. Tento task by mal stačiť pre buildovanie a spúšťanie package-ov, pokiaľ však chcete kód debugoať nemusí to byť dostatočné. Spustiť ho je možné cez **Terminal -> Run Build Task -> colcon: build**. V termináli sa postupne objaví:

![alt text](colcon_default_build_task.png)

![alt text](colcon_default_build_task_finish.png)

Presne preto je možné si zadefinovať vlastné task-y. V koreni workspace by sa mal nachádzať priečinok **.vscode** v ňom môžete vytvoriť **tasks.json**, ktorého prázdna štruktúra by mala vyzerať takto:
```json
{
  "version": "2.0.0",
  "tasks": [

  ]
}
```
Do políčka tasks je možné pridávať rôzne task-y, nie len na buildovanie, ale aj na vyčistenie workspace, testovanie atď. viaceré tasky si môžete pozrieť [tu: How to build with Colcon](https://picknik.ai/vscode/docker/ros2/2024/01/23/ROS2-and-VSCode.html). Najzákladnejší debug build task môže vyzerať takto:
```json
{
    "label": "colcon: build (debug)",
    "type": "shell",
    "command": [
        "colcon build",
        "--symlink-install --merge-install ",
        "--event-handlers console_cohesion+",
        "--base-paths workspace-path",
        "--cmake-args -DCMAKE_BUILD_TYPE=Debug" // Neoptimalizovaný kód - "Debug riadok po riadku"
        //-DCMAKE_BUILD_TYPE=RelWithDebInfo  // Optimalizovaný kód - "Symbolický debug - Nie do úplnej hĺbky"
    ]
}
```
Custom Task-y je možné spúšťať cez **Terminal -> Run Task -> "Task Name"**.

## [Programovanie C++ ROS2 v VSCode (aneb InteliSense)](https://picknik.ai/vscode/docker/ros2/2024/01/23/ROS2-and-VSCode.html)

Keď otvoríte ROS2 projekt vo VSCode v priečinku **.vscode** by mali tiež vzniknúť súbory **c_cpp_properties.json** a **settings.json**. Slúžia hlavne na konfiguráciu dopĺňania a zvýrazňovania kódu, mali by vyzerať nasledovne (špecificky podľa zariadenia a workspacu):
```json
settings.json
{
    "ros.distro": "foxy",
    "python.autoComplete.extraPaths": [
        "c:\\ros2\\udsZad3_ws\\install\\Lib\\site-packages",
        "C:\\opt\\ros\\foxy\\x64\\Lib\\site-packages",
        "C:\\ros2\\udsZad3_ws\\build\\uds_kobuki_ros",
        "c:\\opt\\install\\Lib\\site-packages",
        "C:\\ros2\\udsZad3_ws\\install\\Lib\\site-packages",
        "c:\\opt\\ros\\foxy\\x64\\Lib\\site-packages"
    ],
    "python.analysis.extraPaths": [
        "c:\\ros2\\udsZad3_ws\\install\\Lib\\site-packages",
        "C:\\opt\\ros\\foxy\\x64\\Lib\\site-packages",
        "C:\\ros2\\udsZad3_ws\\build\\uds_kobuki_ros",
        "c:\\opt\\install\\Lib\\site-packages",
        "C:\\ros2\\udsZad3_ws\\install\\Lib\\site-packages",
        "c:\\opt\\ros\\foxy\\x64\\Lib\\site-packages"
    ],
    "files.associations": {
        "memory": "cpp",
        "xlocale": "cpp",
        "xlocinfo": "cpp",
        "xstring": "cpp"
    }
}
```
```json
c_cpp_properties.json
{
  "configurations": [
    {
      "browse": {
        "databaseFilename": "${default}",
        "limitSymbolsToIncludedHeaders": false
      },
      "includePath": [
        "C:\\opt\\ros\\foxy\\x64\\include\\**",
        "c:\\opt\\ros\\foxy\\x64\\include\\**",
        "c:\\ros2\\udsZad3_ws\\src\\uds_test\\include\\**"
        // ${workspaceFolder}/build/package // Pre doplnenie vlastných include ciest
      ],
      "name": "ROS",
      "intelliSenseMode": "msvc-x64",
      "cStandard": "c11",
      "cppStandard": "c++14"
    }
  ],
  "version": 4
}
```

## Debugovanie C++ ROS2 cez VSCode

V priečinku **.vscode** je potrebné vytvoriť **launch.json**, ktorého prázdna štruktúra vyzerá nasledovne:
```json
{
    "version": "0.2.0",
    "configurations": [

    ]
}
```
V poli configurations je možné pridávať viaceré konfigurácie (oddelené čiarkou) debuggera, ktoré sú popísané nižšie.

Debugger sa potom spúšťa cez **Run and Debug** špecificky podľa zvolenej konfigurácie.
![alt text](debugger.png)

### [(**Attach** Debugger) Pripojenie debuggera k bežiacemu kódu](https://picknik.ai/vscode/docker/ros2/2024/01/23/ROS2-and-VSCode.html)

Pripojí debugger k už bežiacej node, ktorá musí byť spustená pred spustením debuggera, konfigurácia pre **launch.json** vyzerá nasledovne:
```json
{
    "name": "ROS: Attach",
    "request": "attach",
    "type": "ros"
}
```
Pri spúšťaní je potrebné do kontextového okna napísať názov executable na ktorý sa má debugger pripojiť.

### (**Launch** Debugger) Spusti debugger zároveň s kódom

Zároveň spustí kód aj debugger, konfigurácia pre **launch.json** vyzerá nasledovne:
```json
{
    "name": "ROS: Launch",
    "type": "ros",
    "request": "launch",
    "target": "C:\\ros2\\udsZad3_ws\\src\\zad3\\launch\\zad3_launch.py" // Alebo jedna Node.exe
}
```
Návod ako vytvárať launch.py sa nachádza tu: https://docs.ros.org/en/foxy/Tutorials/Intermediate/Launch/Creating-Launch-Files.html