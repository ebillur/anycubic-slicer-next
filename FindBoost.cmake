find_path(Boost_INCLUDE_DIR NAMES boost/version.hpp REQUIRED)
set(Boost_INCLUDE_DIRS "${Boost_INCLUDE_DIR}")
file(STRINGS "${Boost_INCLUDE_DIR}/boost/version.hpp" _boost_version_line
  REGEX "^#define BOOST_VERSION [0-9]+$")
string(REGEX MATCH "[0-9]+" Boost_VERSION "${_boost_version_line}")
math(EXPR _boost_major "${Boost_VERSION} / 100000")
math(EXPR _boost_minor "(${Boost_VERSION} / 100) % 1000")
math(EXPR _boost_patch "${Boost_VERSION} % 100")
set(Boost_VERSION_STRING "${_boost_major}.${_boost_minor}.${_boost_patch}")
if(NOT TARGET Boost::boost)
  add_library(Boost::boost INTERFACE IMPORTED)
  set_target_properties(Boost::boost PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${Boost_INCLUDE_DIR}")
endif()
set(_Boost_COMPONENTS ${Boost_FIND_COMPONENTS})
foreach(_component IN LISTS _Boost_COMPONENTS)
  if(_component STREQUAL "system")
    if(NOT TARGET Boost::system)
      add_library(Boost::system INTERFACE IMPORTED)
      set_target_properties(Boost::system PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${Boost_INCLUDE_DIR}")
    endif()
    set(Boost_system_FOUND TRUE)
    set(Boost_SYSTEM_FOUND TRUE)
    list(APPEND Boost_LIBRARIES Boost::system)
    continue()
  endif()
  find_library(Boost_${_component}_LIBRARY
    NAMES boost_${_component}
    REQUIRED)
  if(NOT TARGET Boost::${_component})
    add_library(Boost::${_component} UNKNOWN IMPORTED)
    set_target_properties(Boost::${_component} PROPERTIES
      IMPORTED_LOCATION "${Boost_${_component}_LIBRARY}"
      INTERFACE_INCLUDE_DIRECTORIES "${Boost_INCLUDE_DIR}")
  endif()
  set(Boost_${_component}_FOUND TRUE)
  string(TOUPPER "${_component}" _component_upper)
  set(Boost_${_component_upper}_FOUND TRUE)
  list(APPEND Boost_LIBRARIES Boost::${_component})
endforeach()
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Boost
  REQUIRED_VARS Boost_INCLUDE_DIR
  VERSION_VAR Boost_VERSION_STRING
  HANDLE_COMPONENTS)
