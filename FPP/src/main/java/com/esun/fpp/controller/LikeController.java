package com.esun.fpp.controller;

import com.esun.fpp.model.dto.AddLikeRequest;
import com.esun.fpp.model.dto.LikeItemResponse;
import com.esun.fpp.model.dto.UpdateLikeRequest;
import com.esun.fpp.service.LikeService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.CrossOrigin;

import java.util.List;

@CrossOrigin(origins = "http://localhost:5173")
@RestController
@RequestMapping("/api/likes")
public class LikeController {

    private final LikeService likeService;

    public LikeController(LikeService likeService) {
        this.likeService = likeService;
    }

    // 1. 新增喜好金融商品
    @PostMapping
    public ResponseEntity<Void> addLike(@RequestBody @Valid AddLikeRequest request) {
        likeService.addLike(request);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    // 2. 查詢使用者喜好清單
    @GetMapping("/{userId}")
    public List<LikeItemResponse> getLikes(@PathVariable String userId) {
        return likeService.getLikesByUser(userId);
    }

    // 3. 更改喜好商品資訊（數量 / 帳號）
    @PutMapping("/{sn}")
    public ResponseEntity<Void> updateLike(@PathVariable Integer sn,
                                           @RequestBody @Valid UpdateLikeRequest request) {
        likeService.updateLike(sn, request);
        return ResponseEntity.ok().build();
    }

    // 4. 刪除喜好商品
    @DeleteMapping("/{sn}")
    public ResponseEntity<Void> deleteLike(@PathVariable Integer sn) {
        likeService.deleteLike(sn);
        return ResponseEntity.noContent().build();
    }
}
