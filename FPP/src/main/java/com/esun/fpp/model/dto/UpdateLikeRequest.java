package com.esun.fpp.model.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class UpdateLikeRequest {

    @NotBlank
    private String account;

    @NotNull
    @Min(1)
    private Integer orderQty;
}
