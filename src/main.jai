#import "Basic";
#import "vk_engine";

main :: ()
{
    engine := VulkanEngine.{};

    init(*engine);	
	
	run(*engine);	

	cleanup(*engine);
}