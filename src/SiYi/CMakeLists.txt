add_library(SiYi
    SiYi.cc
    SiYiCamera.cc
    SiYiCrcApi.cc
    SiYiTcpClient.cc
    SiYiTransmitter.cc
)

target_link_libraries(SiYi
    Qt5::Core
    qgc
)
