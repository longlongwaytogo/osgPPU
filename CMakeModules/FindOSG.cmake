# This module defines

# OSG_LIBRARY
# OSG_FOUND, if false, do not try to link to osg
# OSG_INCLUDE_DIRS, where to find the headers
# OSG_INCLUDE_DIR, where to find the source headers
# OSG_GEN_INCLUDE_DIR, where to find the generated headers

# to use this module, set variables to point to the osg build
# directory, and source directory, respectively
# OSGDIR or OSG_SOURCE_DIR: osg source directory, typically OpenSceneGraph
# OSG_DIR or OSG_BUILD_DIR: osg build directory, place in which you've
#    built osg via cmake 

# Header files are presumed to be included like
# #include <osg/PositionAttitudeTransform>
# #include <osgUtil/SceneView>

###### headers ######

SET( CMAKE_DEBUG_POSTFIX d )

MACRO( FIND_OSG_INCLUDE THIS_OSG_INCLUDE_DIR THIS_OSG_INCLUDE_FILE )

# configure matched pair of include / library search paths
SET( OSG_SEARCH_PATHS
    $ENV{OSG_SOURCE_DIR}
    $ENV{OSG_BUILD_DIR}
    ${OSGDIR}
    $ENV{OSGDIR}
    ${OSG_DIR}
    $ENV{OSG_DIR}
    ${OSG_ROOT}
    $ENV{OSG_ROOT}
    ${OSG_ROOT_DEBUG}
    $ENV{OSG_ROOT_DEBUG}
    ${CMAKE_INSTALL_PREFIX}
    ${CMAKE_PREFIX_PATH}
    /usr/local
    /usr
    /sw # Fink
    /opt/local # DarwinPorts
    /opt/csw # Blastwave
    /opt
    /usr/freeware
    [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OSG_ROOT]/
    ~/Library/Frameworks
    /Library/Frameworks
    )

FIND_PATH( ${THIS_OSG_INCLUDE_DIR} ${THIS_OSG_INCLUDE_FILE}
    PATHS           ${OSG_SEARCH_PATHS}
    PATH_SUFFIXES   include build/include Build/include
)

ENDMACRO(FIND_OSG_INCLUDE THIS_OSG_INCLUDE_DIR THIS_OSG_INCLUDE_FILE)

#FIND_OSG_INCLUDE( OSG_GEN_INCLUDE_DIR  osg/Config )
FIND_OSG_INCLUDE( OSG_INCLUDE_DIR      osg/Node )

###### libraries ######

MACRO(FIND_OSG_LIBRARY MYLIBRARY MYLIBRARYNAME)

FIND_LIBRARY(${MYLIBRARY}
    NAMES           ${MYLIBRARYNAME}
    PATHS           ${OSG_SEARCH_PATHS}
    PATH_SUFFIXES   lib build/lib Build/lib
     )

ENDMACRO(FIND_OSG_LIBRARY MYLIBRARY MYLIBRARYNAME)

SET( TMP_LIBRARY_LIST
    OpenThreads osg osgGA osgUtil osgDB osgText osgViewer )

FOREACH(LIBRARY ${TMP_LIBRARY_LIST})
    STRING( TOUPPER ${LIBRARY} UPPPERLIBRARY )
    FIND_OSG_LIBRARY( ${UPPPERLIBRARY}_LIBRARY_RELEASE  ${LIBRARY} )
    FIND_OSG_LIBRARY( ${UPPPERLIBRARY}_LIBRARY_DEBUG    ${LIBRARY}${CMAKE_DEBUG_POSTFIX} )
    LIST( APPEND OSG_LIBRARIES debug ${${UPPPERLIBRARY}_LIBRARY_DEBUG} optimized ${${UPPPERLIBRARY}_LIBRARY_RELEASE} )
ENDFOREACH(LIBRARY ${TMP_LIBRARY_LIST})

SET( OSG_FOUND "NO" )
#IF(OSG_LIBRARY_RELEASE OR OSG_LIBRARY_DEBUG AND OSG_INCLUDE_DIR AND OSG_GEN_INCLUDE_DIR)
#    SET( OSG_FOUND "YES" )
#    SET( OSG_INCLUDE_DIRS ${OSG_INCLUDE_DIR} ${OSG_GEN_INCLUDE_DIR} )
#    GET_FILENAME_COMPONENT( OSG_LIBRARY_DIR_RELEASE ${OSG_LIBRARY_RELEASE} PATH )
#    GET_FILENAME_COMPONENT( OSG_LIBRARY_DIR_DEBUG   ${OSG_LIBRARY_DEBUG}     PATH )
#    SET( OSG_LIBRARY_DIRS ${OSG_LIBRARY_DIR_RELEASE} ${OSG_LIBRARY_DIR_DEBUG} )
#ENDIF(OSG_LIBRARY_RELEASE OR OSG_LIBRARY_DEBUG AND OSG_INCLUDE_DIR AND OSG_GEN_INCLUDE_DIR)


IF(OSG_LIBRARY_RELEASE OR OSG_LIBRARY_DEBUG AND OSG_INCLUDE_DIR)
    SET( OSG_FOUND "YES" )
    SET( OSG_INCLUDE_DIRS ${OSG_INCLUDE_DIR} )
    GET_FILENAME_COMPONENT( OSG_LIBRARY_DIR_RELEASE ${OSG_LIBRARY_RELEASE} PATH )
    GET_FILENAME_COMPONENT( OSG_LIBRARY_DIR_DEBUG   ${OSG_LIBRARY_DEBUG}     PATH )
    SET( OSG_LIBRARY_DIRS ${OSG_LIBRARY_DIR_RELEASE} ${OSG_LIBRARY_DIR_DEBUG} )
ENDIF(OSG_LIBRARY_RELEASE OR OSG_LIBRARY_DEBUG AND OSG_INCLUDE_DIR)

