#import "Basic";
#import "Vulkan";
#import "Window_Creation";
#import "Input";

#load "vk_types.jai";
#load "vk_initializers.jai";

loadedEngine: *VulkanEngine = null;

VulkanEngine :: struct {

    _isInitialized:= false;
    _frameNumber:= 0;
    stop_rendering:= false;
    _windowExtent: VkExtent2D = .{ 1700, 900 };

    _window : Window_Type;
}

Get :: () -> *VulkanEngine {
 	return loadedEngine;
}

//initializes everything in the engine
init::(engine: *VulkanEngine){
	// only one engine initialization is allowed with the application.
 	assert(loadedEngine == null);
 	loadedEngine = engine;

 	//Create a window
	engine._window = create_window(engine._windowExtent.width, engine._windowExtent.height, "Vulkan Engine");

 	// everything went fine
 	engine._isInitialized = true;
}

//shuts down the engine
cleanup::(engine: *VulkanEngine){
	if (engine._isInitialized) {}

    // clear engine pointer
    loadedEngine = null;
}

//draw loop
draw::(engine: *VulkanEngine){
	// nothing yet
}

//run main loop
run::(engine: *VulkanEngine){
	bQuit := false;

	// main loop
    while !bQuit
    {
        update_window_events();
        for events_this_frame
        {
            if it.type == {
                // close the window when user alt-f4s or clicks the X button
                case .QUIT;
                    bQuit = true;
                case .WINDOW_MINIMIZE;
                    engine.stop_rendering = true;
                case .WINDOW_RESTORE;
                    engine.stop_rendering = false;
            }
        }

		// do not draw if we are minimized
        if engine.stop_rendering {
            // throttle the speed to avoid the endless spinning
			sleep_milliseconds(100);
            continue;
        }

        draw(engine);
    }
}