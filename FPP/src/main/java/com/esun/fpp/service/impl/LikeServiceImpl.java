package com.esun.fpp.service.impl;

import com.esun.fpp.model.dto.AddLikeRequest;
import com.esun.fpp.model.dto.LikeItemResponse;
import com.esun.fpp.model.dto.UpdateLikeRequest;
import com.esun.fpp.repository.LikeRepository;
import com.esun.fpp.service.LikeService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class LikeServiceImpl implements LikeService {

    private final LikeRepository likeRepository;

    public LikeServiceImpl(LikeRepository likeRepository) {
        this.likeRepository = likeRepository;
    }

    @Override
    @Transactional
    public void addLike(AddLikeRequest request) {
        likeRepository.addLike(request);
    }

    @Override
    @Transactional(readOnly = true)
    public List<LikeItemResponse> getLikesByUser(String userId) {
        return likeRepository.findByUserId(userId);
    }

    @Override
    @Transactional
    public void updateLike(Integer sn, UpdateLikeRequest request) {
        likeRepository.updateLike(sn, request);
    }

    @Override
    @Transactional
    public void deleteLike(Integer sn) {
        likeRepository.deleteLike(sn);
    }
}
