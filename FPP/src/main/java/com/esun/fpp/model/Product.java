package com.esun.fpp.model;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class Product {
    private Integer productNo;
    private String productName;
    private BigDecimal price;
    private BigDecimal  feeRate;
}

