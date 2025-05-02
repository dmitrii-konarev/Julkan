#import "Vulkan";

vkinit :: struct{
//> init_cmd
command_pool_create_info :: (queueFamilyIndex: u32, flags: VkCommandPoolCreateFlags = 0) -> VkCommandPoolCreateInfo {
    info: VkCommandPoolCreateInfo;
    info.sType = .COMMAND_POOL_CREATE_INFO;
    info.pNext = null;
    info.queueFamilyIndex = queueFamilyIndex;
    info.flags = flags;
    return info;
}

command_buffer_allocate_info :: (pool: VkCommandPool, count: u32 = 1) -> VkCommandBufferAllocateInfo {
    info: VkCommandBufferAllocateInfo;
    info.sType = .COMMAND_BUFFER_ALLOCATE_INFO;
    info.pNext = null;
    info.commandPool = pool;
    info.commandBufferCount = count;
    info.level = .PRIMARY;
    return info;
}
//< init_cmd

//> init_cmd_draw
command_buffer_begin_info :: (flags: VkCommandBufferUsageFlags = 0) -> VkCommandBufferBeginInfo {
    info: VkCommandBufferBeginInfo;
    info.sType = .COMMAND_BUFFER_BEGIN_INFO;
    info.pNext = null;
    info.pInheritanceInfo = null;
    info.flags = flags;
    return info;
}
//< init_cmd_draw

//> init_sync
fence_create_info :: (flags: VkFenceCreateFlags = 0) -> VkFenceCreateInfo {
    info: VkFenceCreateInfo;
    info.sType = .FENCE_CREATE_INFO;
    info.pNext = null;
    info.flags = flags;
    return info;
}

semaphore_create_info :: (flags: VkSemaphoreCreateFlags = 0) -> VkSemaphoreCreateInfo {
    info: VkSemaphoreCreateInfo;
    info.sType = .SEMAPHORE_CREATE_INFO;
    info.pNext = null;
    info.flags = flags;
    return info;
}
//< init_sync

//> init_submit
semaphore_submit_info :: (stageMask: VkPipelineStageFlags2, semaphore: VkSemaphore) -> VkSemaphoreSubmitInfo {
    info: VkSemaphoreSubmitInfo;
    info.sType = .SEMAPHORE_SUBMIT_INFO;
    info.pNext = null;
    info.semaphore = semaphore;
    info.stageMask = stageMask;
    info.deviceIndex = 0;
    info.value = 1;
    return info;
}

command_buffer_submit_info :: (cmd: VkCommandBuffer) -> VkCommandBufferSubmitInfo {
    info: VkCommandBufferSubmitInfo;
    info.sType = .COMMAND_BUFFER_SUBMIT_INFO;
    info.pNext = null;
    info.commandBuffer = cmd;
    info.deviceMask = 0;
    return info;
}

submit_info :: (cmd: *VkCommandBufferSubmitInfo, signalSemaphoreInfo: *VkSemaphoreSubmitInfo = null, 
               waitSemaphoreInfo: *VkSemaphoreSubmitInfo = null) -> VkSubmitInfo2 {
    info: VkSubmitInfo2;
    info.sType = .SUBMIT_INFO_2;
    info.pNext = null;
    
    info.waitSemaphoreInfoCount = xx ifx waitSemaphoreInfo == null then 0 else 1;
    info.pWaitSemaphoreInfos = waitSemaphoreInfo;
    
    info.signalSemaphoreInfoCount = xx ifx signalSemaphoreInfo == null then 0 else 1;
    info.pSignalSemaphoreInfos = signalSemaphoreInfo;
    
    info.commandBufferInfoCount = 1;
    info.pCommandBufferInfos = cmd;
    
    return info;
}
//< init_submit

present_info :: () -> VkPresentInfoKHR {
    info: VkPresentInfoKHR;
    info.sType = .PRESENT_INFO_KHR;
    info.pNext = null;
    
    info.swapchainCount = 0;
    info.pSwapchains = null;
    info.pWaitSemaphores = null;
    info.waitSemaphoreCount = 0;
    info.pImageIndices = null;
    
    return info;
}

//> color_info
attachment_info :: (view: VkImageView, clear: *VkClearValue = null, 
                   layout: VkImageLayout = .COLOR_ATTACHMENT_OPTIMAL) -> VkRenderingAttachmentInfo {
    attachment: VkRenderingAttachmentInfo;
    attachment.sType = .RENDERING_ATTACHMENT_INFO;
    attachment.pNext = null;
    
    attachment.imageView = view;
    attachment.imageLayout = layout;
    attachment.loadOp = ifx clear != null then .CLEAR else .LOAD;
    attachment.storeOp = .STORE;
    
    if clear != null {
        attachment.clearValue = clear.*;
    }
    
    return attachment;
}
//< color_info

//> depth_info
depth_attachment_info :: (view: VkImageView, 
                         layout: VkImageLayout = .COLOR_ATTACHMENT_OPTIMAL) -> VkRenderingAttachmentInfo {
    attachment: VkRenderingAttachmentInfo;
    attachment.sType = .RENDERING_ATTACHMENT_INFO;
    attachment.pNext = null;
    
    attachment.imageView = view;
    attachment.imageLayout = layout;
    attachment.loadOp = .CLEAR;
    attachment.storeOp = .STORE;
    attachment.clearValue.depthStencil.depth = 0.;
    
    return attachment;
}
//< depth_info

//> render_info
rendering_info :: (renderExtent: VkExtent2D, colorAttachment: *VkRenderingAttachmentInfo,
                  depthAttachment: *VkRenderingAttachmentInfo = null) -> VkRenderingInfo {
    info: VkRenderingInfo;
    info.sType = .RENDERING_INFO;
    info.pNext = null;
    
    info.renderArea.offset = .{ 0, 0 };
    info.renderArea.extent = renderExtent;
    info.layerCount = 1;
    info.colorAttachmentCount = 1;
    info.pColorAttachments = colorAttachment;
    info.pDepthAttachment = depthAttachment;
    info.pStencilAttachment = null;
    
    return info;
}
//< render_info

//> subresource
image_subresource_range :: (aspectMask: VkImageAspectFlags) -> VkImageSubresourceRange {
    subrange: VkImageSubresourceRange;
    subrange.aspectMask = aspectMask;
    subrange.baseMipLevel = 0;
    subrange.levelCount = VK_REMAINING_MIP_LEVELS;
    subrange.baseArrayLayer = 0;
    subrange.layerCount = VK_REMAINING_ARRAY_LAYERS;
    
    return subrange;
}
//< subresource

descriptorset_layout_binding :: (type: VkDescriptorType, stageFlags: VkShaderStageFlags,
                               binding: u32) -> VkDescriptorSetLayoutBinding {
    bind: VkDescriptorSetLayoutBinding;
    bind.binding = binding;
    bind.descriptorCount = 1;
    bind.descriptorType = type;
    bind.pImmutableSamplers = null;
    bind.stageFlags = stageFlags;
    
    return bind;
}

descriptorset_layout_create_info :: (bindings: *VkDescriptorSetLayoutBinding,
                                   bindingCount: u32) -> VkDescriptorSetLayoutCreateInfo {
    info: VkDescriptorSetLayoutCreateInfo;
    info.sType = .DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
    info.pNext = null;
    
    info.pBindings = bindings;
    info.bindingCount = bindingCount;
    info.flags = 0;
    
    return info;
}

write_descriptor_image :: (type: VkDescriptorType, dstSet: VkDescriptorSet,
                         imageInfo: *VkDescriptorImageInfo, binding: u32) -> VkWriteDescriptorSet {
    write: VkWriteDescriptorSet;
    write.sType = .WRITE_DESCRIPTOR_SET;
    write.pNext = null;
    
    write.dstBinding = binding;
    write.dstSet = dstSet;
    write.descriptorCount = 1;
    write.descriptorType = type;
    write.pImageInfo = imageInfo;
    
    return write;
}

write_descriptor_buffer :: (type: VkDescriptorType, dstSet: VkDescriptorSet,
                          bufferInfo: *VkDescriptorBufferInfo, binding: u32) -> VkWriteDescriptorSet {
    write: VkWriteDescriptorSet;
    write.sType = .WRITE_DESCRIPTOR_SET;
    write.pNext = null;
    
    write.dstBinding = binding;
    write.dstSet = dstSet;
    write.descriptorCount = 1;
    write.descriptorType = type;
    write.pBufferInfo = bufferInfo;
    
    return write;
}

buffer_info :: (buffer: VkBuffer, offset: VkDeviceSize, range: VkDeviceSize) -> VkDescriptorBufferInfo {
    info: VkDescriptorBufferInfo;
    info.buffer = buffer;
    info.offset = offset;
    info.range = range;
    return info;
}

//> image_set
image_create_info :: (format: VkFormat, usageFlags: VkImageUsageFlags, 
                    extent: VkExtent3D) -> VkImageCreateInfo {
    info: VkImageCreateInfo;
    info.sType = .IMAGE_CREATE_INFO;
    info.pNext = null;
    
    info.imageType = ._2D;
    info.format = format;
    info.extent = extent;
    
    info.mipLevels = 1;
    info.arrayLayers = 1;

    //for MSAA. we will not be using it by default, so default it to 1 sample per pixel.
    info.samples = ._1_BIT;

    //optimal tiling, which means the image is stored on the best gpu format
    info.tiling = .OPTIMAL;
    info.usage = usageFlags;
    
    return info;
}

imageview_create_info :: (format: VkFormat, image: VkImage, 
                        aspectFlags: VkImageAspectFlags) -> VkImageViewCreateInfo {
    // build a image-view for the depth image to use for rendering
    info: VkImageViewCreateInfo;
    info.sType = .IMAGE_VIEW_CREATE_INFO;
    info.pNext = null;
    
    info.viewType = ._2D;
    info.image = image;
    info.format = format;
    info.subresourceRange.baseMipLevel = 0;
    info.subresourceRange.levelCount = 1;
    info.subresourceRange.baseArrayLayer = 0;
    info.subresourceRange.layerCount = 1;
    info.subresourceRange.aspectMask = aspectFlags;
    
    return info;
}
//< image_set

pipeline_layout_create_info :: () -> VkPipelineLayoutCreateInfo {
    info: VkPipelineLayoutCreateInfo;
    info.sType = .PIPELINE_LAYOUT_CREATE_INFO;
    info.pNext = null;
    
    info.flags = 0;
    info.setLayoutCount = 0;
    info.pSetLayouts = null;
    info.pushConstantRangeCount = 0;
    info.pPushConstantRanges = null;
    
    return info;
}

pipeline_shader_stage_create_info :: (stage: VkShaderStageFlagBits,
                                    shaderModule: VkShaderModule,
                                    entry: string = "main") -> VkPipelineShaderStageCreateInfo {
    info: VkPipelineShaderStageCreateInfo;
    info.sType = .PIPELINE_SHADER_STAGE_CREATE_INFO;
    info.pNext = null;

    info.stage = stage;
    info.module = shaderModule;
    info.pName = entry.data;
    
    return info;
}
}