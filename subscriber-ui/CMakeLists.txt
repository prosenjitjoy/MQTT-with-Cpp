cmake_minimum_required(VERSION 3.31)
project(MqttSubscriber VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 26)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Mqtt Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appMqttSubscriber
    main.cpp
)

qt_add_qml_module(appMqttSubscriber
    URI MqttSubscriber
    VERSION 1.0
    QML_FILES
        Main.qml
        SOURCES qmlmqttsubscription.h qmlmqttsubscription.cpp
)

target_link_libraries(appMqttSubscriber
    PRIVATE Qt6::Mqtt Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appMqttSubscriber
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
