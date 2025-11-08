package com.gym.controller;

import com.gym.common.R;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Api(tags = "测试接口")
@RestController
@RequestMapping("/test")
public class TestController {

    @ApiOperation("测试R类功能")
    @GetMapping("/r")
    public R<String> testR() {
        return R.ok("Knife4j测试成功！");
    }

    @ApiOperation("测试错误响应")
    @GetMapping("/r/error")
    public R<String> testError() {
        return R.fail("这是一个错误响应测试");
    }

    @ApiOperation("健康检查")
    @GetMapping("/health")
    public R<String> health() {
        return R.ok("服务运行正常");
    }
}