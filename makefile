# A sample Makefile
# This Makefile demonstrates and explains 
# Make Macros, Macro Expansions,
# Rules, Targets, Dependencies, Commands, Goals
# Artificial Targets, Pattern Rule, Dependency Rule.

#variable definitions

INC_DIR = inc
INC_DATA_DIR = inc/data

SRC_DIR = src
OBJ_DIR = obj
CC = g++
DEBUG = -g
CFLAGS  = -Wall -I$(INC_DIR) -I$(INC_DATA_DIR) 
OPTION = -lm
# -std=c++17
# What's the meaing of '-c' options?
# CFLAGS = -Wall -ansi -std=c99 $(DEBUG) -c
# LFLAGS = -Wall $(DEBUG)
# -Werror : Waring = error
# Comments start with a # and go to the end of the line.
# Here is a simple Make Macro.
LINK_TARGET = main.exe

DLL_TARGET = nalx.dll

# Here is a Make Macro that uses the backslash to extend to multiple lines.
SRCS =  \
	$(SRC_DIR)/main.cpp \
	$(SRC_DIR)/NALX.cpp \
	$(SRC_DIR)/OliveHearingGain.cpp \
	$(SRC_DIR)/NAL-NL2.cpp \
	$(SRC_DIR)/NL2.cpp \

OBJS =  \
	$(OBJ_DIR)/main.o \
	$(OBJ_DIR)/NALX.o \
	$(OBJ_DIR)/OliveHearingGain.o \
	$(OBJ_DIR)/NAL-NL2.o \
	$(OBJ_DIR)/NL2.o \

DEPS = \
	$(INC_DIR)/*.h \


SRCS_EXPORT =  \
	$(SRC_DIR)/NALX.cpp \
	$(SRC_DIR)/OliveHearingGain.cpp \
	$(SRC_DIR)/NAL-NL2.cpp \
	$(SRC_DIR)/NL2.cpp \

OBJS_EXPORT =  \
	$(OBJ_DIR)/NALX.o \
	$(OBJ_DIR)/OliveHearingGain.o \
	$(OBJ_DIR)/NAL-NL2.o \
	$(OBJ_DIR)/NL2.o \

# Here is a Make Macro defined by two Macro Expansions.
# A Macro Expansion may be treated as a textual replacement of the Make Macro.
# Macro Expansions are introduced with $ and enclosed in (parentheses).
REBUILDABLES = $(OBJS) $(LINK_TARGET) $(DLL_TARGET)

# Here is a simple Rule (used for "cleaning" your build environment).
# It has a Target named "clean" (left of the colon ":" on the first line),
# no Dependencies (right of the colon),
# Dependencies is like list and pick out the values
# and two Commands (indented by tabs on the lines that follow).
# The space before the colon is not required but added here for clarity.
clean : 
	rm -f $(REBUILDABLES)
	echo Clean done

# There are two standard Targets your Makefile should probably have:
# "all" and "clean", because they are often command-line Goals.
# Also, these are both typically Artificial Targets, because they don't typically
# correspond to real files named "all" or "clean".  
dll : $(DLL_TARGET)
	echo All DLL done

$(DLL_TARGET): $(OBJS_EXPORT)
	echo $@ $^
	$(CC) $(CFLAGS) -shared -o $@ $^ $(OPTION) 

$(OBJ_DIR)/%.o : $(SRC_DIR)/%.cpp
	echo $@ $<
	$(CC) $(CFLAGS) -c $< -o $@ $(OPTION)

NALX.o : $(SRC_DIR)/*.h
OliveHearingGain.o : $(SRC_DIR)/config.h $(SRC_DIR)/OliveHearingGain.h
NAL-NL2.o : $(SRC_DIR)/NL2.h $(SRC_DIR)/NAL-NL2.h $(INC_DIR)/constants.h
NL2.o : $(SRC_DIR)/NL2.h $(INC_DIR)/constants.h $(INC_DATA_DIR)/*.h

# The rule for "all" is used to incrementally build your system.
# It does this by expressing a dependency on the results of that system,
# which in turn have their own rules and dependencies.
all : $(LINK_TARGET)
	echo All done

# There is no required order to the list of rules as they appear in the Makefile.
# Make will build its own dependency tree and only execute each rule only once
# its dependencies' rules have been executed successfully.

# Here is a Rule that uses some built-in Make Macros in its command:
# $@ expands to the rule's target, in this case "main.exe".
# $^ expands to the rule's dependencies, in this case the three files
# main.o, test1.o, and  test2.o.
$(LINK_TARGET) : $(OBJS)
	echo $@ $^
	$(CC) $(CFLAGS) -o $@ $^

# Here is a Pattern Rule, often used for compile-line.
# It says how to create a file with a .o suffix, given a file with a .cpp suffix.
# The rule's command uses some built-in Make Macros:
# $@ for the pattern-matched target
# $< for the pattern-matched dependency
$(OBJ_DIR)/%.o : $(SRC_DIR)/%.cpp
	echo $@ $<
	$(CC) $(CFLAGS) -c $< -o $@ $(OPTION)
# -dM -E 
# -I/data -I/include 

# These are Dependency Rules, which are rules without any command.
# Dependency Rules indicate that if any file to the right of the colon changes,
# the target to the left of the colon should be considered out-of-date.
# The commands for making an out-of-date target up-to-date may be found elsewhere
# (in this case, by the Pattern Rule above).
# Dependency Rules are often used to capture header file dependencies.

main.o : $(SRC_DIR)/NALX.h
NALX.o : $(SRC_DIR)/*.h
OliveHearingGain.o : $(SRC_DIR)/config.h $(SRC_DIR)/OliveHearingGain.h
NAL-NL2.o : $(SRC_DIR)/NL2.h $(SRC_DIR)/NAL-NL2.h $(INC_DIR)/constants.h
NL2.o : $(SRC_DIR)/NL2.h $(INC_DIR)/constants.h $(INC_DATA_DIR)/*.h

# constants.h res_101.h res_102.h res_102.h res_103.h res_104.h res_105.h res_106.h res_107.h res_108.h res_109.h res_110.h res_111.h res_112.h res_113.h res_114.h res_115.h res_116.h res_117.h res_118.h res_119.h res_120.h res_121.h res_122.h res_123.h res_124.h 

# Alternatively to manually capturing dependencies, several automated
# dependency generators exist.  Here is one possibility (commented out)...
# %.dep : %.cpp
#  	g++ -M $(FLAGS) $< > $@
# include $(OBJS:.o=.dep)