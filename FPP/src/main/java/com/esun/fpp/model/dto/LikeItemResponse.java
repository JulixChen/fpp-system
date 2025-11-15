package com.esun.fpp.model.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class LikeItemResponse {

    private Integer sn;
    private String productName;
    private Integer orderQty;
    private String account;
    private BigDecimal totalAmount;
    private BigDecimal totalFee;
    private String email;
    private String userName;
}
