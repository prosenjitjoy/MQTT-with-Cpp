cmake_minimum_required(VERSION 3.31)
project(MqttPublisher VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 26)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Mqtt Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appMqttPublisher
    main.cpp
)

qt_add_qml_module(appMqttPublisher
    URI MqttPublisher
    VERSION 1.0
    QML_FILES
        Main.qml
        SOURCES qmlmqttclient.h qmlmqttclient.cpp
)

target_link_libraries(appMqttPublisher
    PRIVATE Qt6::Mqtt Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appMqttPublisher
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
