cmake_minimum_required(VERSION 3.31)
project(cpp-mqtt LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 26)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Mqtt)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(cpp-mqtt
    main.cpp
)

target_link_libraries(cpp-mqtt
    PRIVATE Qt::Core Qt::Mqtt
)

include(GNUInstallDirs)
install(TARGETS cpp-mqtt
    BUNDLE  DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
