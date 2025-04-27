VK_CHECK :: (result: VkResult, message := "") -> VkResult {
    if result != .SUCCESS {
        print("Detected Vulkan error: %\n", string_VkResult(result));
        if message then print("Error context: %\n", message);
        exit(1);
    }
    return result;
}