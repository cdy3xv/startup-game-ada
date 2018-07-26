cmake_minimum_required(VERSION 2.8)

project(ada-game)

# Requires github.com/offa/cmake-ada
enable_language(ADA)

set(CMAKE_ADA_FLAGS "${CMAKE_ADA_FLAGS} -gnat12")

set(ALL_SDB_FILES
    src/component_pkg.adb
    src/fuel_system_pkg.adb
    src/engine_pkg.adb
    src/tank_pkg.adb
    src/main.adb
    )

foreach(FILE ${ALL_SDB_FILES})
    get_filename_component(FILE_NAME ${FILE} NAME_WE)
    set(ALL_ALI_FILES ${ALL_ALI_FILES};${FILE_NAME}.ali)
    set(ALL_O_FILES ${ALL_O_FILES};${FILE_NAME}.o)
endforeach()

add_executable(${PROJECT_NAME} ${ALL_SDB_FILES})

set_property(DIRECTORY PROPERTY ADDITIONAL_MAKE_CLEAN_FILES ${ALL_ALI_FILES} ${ALL_O_FILES})

