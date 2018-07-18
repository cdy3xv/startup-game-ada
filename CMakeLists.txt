cmake_minimum_required(VERSION 2.8)

project(ada-game)

# Requires github.com/offa/cmake-ada
enable_language(ADA)

set(ALL_SDB_FILES
    src/employee.adb
    src/main.adb
    )

foreach(FILE ${ALL_SDB_FILES})
    get_filename_component(FILE_NAME ${FILE} NAME_WE)
    set(ALL_ALI_FILES ${ALL_ALI_FILES};${FILE_NAME}.ali)
    set(ALL_O_FILES ${ALL_O_FILES};${FILE_NAME}.o)
endforeach()

add_executable(${PROJECT_NAME} ${ALL_SDB_FILES})

set_property(DIRECTORY PROPERTY ADDITIONAL_MAKE_CLEAN_FILES ${ALL_ALI_FILES} ${ALL_O_FILES})

