@echo off

rem Initialize console with Visual Studio environment
call %~dp0\ros2init.bat

rem Start kobuki robot
echo ^>^> Starting ^"uds_kobuki_ros^" robot
ros2 run uds_kobuki_ros uds_kobuki_ros

rem Keep the console window open
cmd /k