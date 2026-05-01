#!/usr/bin/env fish

set PRODUCT_NAME Gutwound
set BUILD_DIR build
set PDX_DIR $BUILD_DIR/$PRODUCT_NAME.pdx
set GAME_PATH $PLAYDATE_SDK_PATH/Disk/Games/$PRODUCT_NAME.pdx

# Platform-specific shared library extension
switch (uname)
    case Darwin
        set LIB_EXT dylib
    case '*'
        set LIB_EXT so
end

# Build shared library for the simulator
mkdir -p $BUILD_DIR
odin build src/ -out:$BUILD_DIR/pdex.$LIB_EXT -build-mode:shared -default-to-nil-allocator; or exit 1

# Copy assets into build dir for pdc
cp src/pdxinfo $BUILD_DIR/
if test -d src/assets
    cp -r src/assets $BUILD_DIR/
end

# Compile with Playdate compiler
$PLAYDATE_SDK_PATH/bin/pdc $BUILD_DIR $PDX_DIR; or exit 1

# Symlink into simulator games folder
if test -L $GAME_PATH
    rm -rf $GAME_PATH
end
ln -s (pwd)/$PDX_DIR $GAME_PATH

# Run simulator
$PDSIM $GAME_PATH
