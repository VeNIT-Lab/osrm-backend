include (CheckCXXCompilerFlag)
include (CheckCCompilerFlag)

# Try to add -Wflag if compiler supports it (GCC/Clang)
macro (add_warning flag)
    string(REPLACE "-" "_" underscored_flag ${flag})
    string(REPLACE "+" "x" underscored_flag ${underscored_flag})

    check_cxx_compiler_flag("-W${flag}" SUPPORTS_CXXFLAG_${underscored_flag})
    check_c_compiler_flag("-W${flag}" SUPPORTS_CFLAG_${underscored_flag})

    if (SUPPORTS_CXXFLAG_${underscored_flag})
        set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -W${flag}")
    else()
        message (STATUS "Flag -W${flag} is unsupported")
    endif()

    if (SUPPORTS_CFLAG_${underscored_flag})
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -W${flag}")
    else()
        message(STATUS "Flag -W${flag} is unsupported")
    endif()
endmacro()

# MSVC warning management macros
macro (msvc_warning_level level)
    if (MSVC)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W${level}")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /W${level}")
    endif()
endmacro()

# Disable specific MSVC warning by code (e.g., 4711)
macro (msvc_disable_warning code)
    if (MSVC)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd${code}")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /wd${code}")
    endif()
endmacro()

# Enable specific MSVC warning by code
macro (msvc_enable_warning code)
    if (MSVC)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /w1${code}")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /w1${code}")
    endif()
endmacro()

# Disable MSVC warning for specific target
macro (target_msvc_disable_warning target code)
    if (MSVC)
        target_compile_options(${target} PRIVATE "/wd${code}")
    endif()
endmacro()

# Try to add -Wno flag if compiler supports it
macro (no_warning flag)
    add_warning(no-${flag})
endmacro ()


# The same but only for specified target.
macro (target_add_warning target flag)
    string (REPLACE "-" "_" underscored_flag ${flag})
    string (REPLACE "+" "x" underscored_flag ${underscored_flag})

    check_cxx_compiler_flag("-W${flag}" SUPPORTS_CXXFLAG_${underscored_flag})

    if (SUPPORTS_CXXFLAG_${underscored_flag})
        target_compile_options (${target} PRIVATE "-W${flag}")
    else ()
        message (STATUS "Flag -W${flag} is unsupported")
    endif ()
endmacro ()

macro (target_no_warning target flag)
    target_add_warning(${target} no-${flag})
endmacro ()