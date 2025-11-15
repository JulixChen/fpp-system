package com.esun.fpp.model.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class AddLikeRequest {

    @NotBlank
    private String userId;

    @NotNull
    private Integer productNo;

    @NotNull
    @Min(1)
    private Integer orderQty;

    @NotBlank
    private String account;
}

