set(SRC_LIST main.cc)
set(LIBS spdlog api app layer global smtp_grpc_proto ${_REFLECTION} ${_GRPC_GRPCPP} ${_PROTOBUF_LIBPROTOBUF})
set(CMAKE_INSTALL_RPATH "/usr/local/lib")
add_subdirectory(./api)
add_subdirectory(./app)
add_subdirectory(./base)
add_subdirectory(./layer)
add_subdirectory(./global)
add_subdirectory(./Grpc)

add_executable(atsys ${SRC_LIST})
target_link_libraries(atsys ${LIBS})
install(TARGETS atsys DESTINATION sbin)
install(TARGETS smtp_server DESTINATION sbin)