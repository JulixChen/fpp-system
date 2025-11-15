package com.esun.fpp.service.impl;

import com.esun.fpp.model.Product;
import com.esun.fpp.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public List<Product> getAll() {
        String sql = "SELECT No AS productNo, " +
                "       ProductName AS productName, " +
                "       Price AS price, " +
                "       FeeRate AS feeRate " +
                "FROM Product";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Product.class));
    }
}

