#CC=g++
#CFLAGS=-I.
#
#COMMON_SOURCES = SimCell.cpp
#TARGET_SOURCES = main.cpp SimMatrix.cpp GameOfLife.cpp
#TEST_SOURCES = main_test.cpp SimCell_test.cpp 
#
#COMMON_OBJECTS = $(COMMON_SOURCES:.cpp=.o)
#TARGET_OBJECTS = $(TARGET_SOURCES:.cpp=.o)
#TEST_OBJECTS = $(TEST_SOURCES:.cpp=.o)
#
#EXECUTABLE = GameOfLife
#TEST_EXECUTABLE = Test
#
#.PHONY: all target tests
#
#all: target tests
#
#target: $(EXECUTABLE)
#tests: $(TEST_EXECUTABLE)
#
#
#$(EXECUTABLE): $(COMMON_OBJECTS) $(TARGET_OBJECTS)
#	$(CC) $(LDFLAGS) $^ -o $@
#
#$(TEST_EXECUTABLE): $(COMMON_OBJECTS) $(TEST_OBJECTS)
#	$(CC) $(LDFLAGS) $^ -o $@
#
#.cpp.o:
#	$(CC) $(CFLAGS) $< -o $@
#


EXECUTABLE := GameOfLife
TEST_EXECUTABLE := Test

.PHONY: all target test

CXX := g++
CXXFLAGS := -Wall -g3
CXXFLAGS := -Wall -std=c++11

TARGET_SOURCES := $(shell find src/ -name "*.cpp")
TARGET_OBJECTS := $(patsubst %.cpp, %.o, $(TARGET_SOURCES))

TEST_SOURCES := $(shell find test/ -name "*.cpp")

#Filter out main_test.cpp and SimCell_test.cpp for now, tests are written only for arguments parser for now
#TEST_SOURCES := $(filter-out test/main_test.cpp test/SimCell_test.cpp, $(TEST_SOURCES))

#Add those files under test from ./src
TEST_SOURCES += src/InputParameterParser.cpp src/SimCell.cpp src/SimMatrix.cpp

TEST_OBJECTS := $(patsubst %.cpp, %.o, $(TEST_SOURCES))

all: target test
#May be a problem, the order of arguments matters for linkage of the test part of project
GTEST_FLAGS := -I $$GTEST_HOME/include -L $$GTEST_HOME/lib -lgtest -lgtest_main -lpthread 

target: $(EXECUTABLE)
test: $(TEST_EXECUTABLE)

$(EXECUTABLE): $(TARGET_OBJECTS)
	    $(CXX) $(CXXFLAGS) $(LDFLAGS) -o $(EXECUTABLE) $(TARGET_OBJECTS) $(LDLIBS)

$(TEST_EXECUTABLE): $(TEST_OBJECTS)
	    $(CXX) $(CXXFLAGS) $(LDFLAGS) -o $(TEST_EXECUTABLE) $(TEST_OBJECTS) $(LDLIBS) $(GTEST_FLAGS)

depend: .depend

.depend: $(TARGET_SOURCES)
	    rm -f ./.depend
	        $(CXX) $(CXXFLAGS) -MM $^>>./.depend;

clean:
	#Deleting source object files
	rm -f $(TARGET_OBJECTS)
	#Deleting test object files
	rm -f $(TEST_OBJECTS)
dist-clean: clean
	   rm -f *~ .depend

include .depend
