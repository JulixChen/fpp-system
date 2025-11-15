package com.esun.fpp.service;

import com.esun.fpp.model.dto.AddLikeRequest;
import com.esun.fpp.model.dto.LikeItemResponse;
import com.esun.fpp.model.dto.UpdateLikeRequest;

import java.util.List;

public interface LikeService {

    void addLike(AddLikeRequest request);

    List<LikeItemResponse> getLikesByUser(String userId);

    void updateLike(Integer sn, UpdateLikeRequest request);

    void deleteLike(Integer sn);
}
