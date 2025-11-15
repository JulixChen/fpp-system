package com.esun.fpp.repository;

import com.esun.fpp.model.dto.AddLikeRequest;
import com.esun.fpp.model.dto.LikeItemResponse;
import com.esun.fpp.model.dto.UpdateLikeRequest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class LikeRepository {

    private final JdbcTemplate jdbcTemplate;

    public LikeRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // 新增喜好商品
    public void addLike(AddLikeRequest req) {
        jdbcTemplate.update(
                "EXEC usp_AddLikeItem ?, ?, ?, ?",
                req.getUserId(),
                req.getProductNo(),
                req.getOrderQty(),
                req.getAccount()
        );
    }

    // 依 userId 查清單
    public List<LikeItemResponse> findByUserId(String userId) {
        return jdbcTemplate.query(
                "EXEC usp_GetLikeListByUser ?",
                ps -> ps.setString(1, userId),
                (rs, rowNum) -> {
                    LikeItemResponse item = new LikeItemResponse();
                    item.setSn(rs.getInt("SN"));
                    item.setProductName(rs.getString("ProductName"));
                    item.setOrderQty(rs.getInt("OrderQty"));
                    item.setAccount(rs.getString("Account"));
                    item.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                    item.setTotalFee(rs.getBigDecimal("TotalFee"));
                    item.setEmail(rs.getString("Email"));
                    item.setUserName(rs.getString("UserName"));
                    return item;
                }
        );
    }

    // 更新
    public void updateLike(Integer sn, UpdateLikeRequest req) {
        jdbcTemplate.update(
                "EXEC usp_UpdateLikeItem ?, ?, ?",
                sn,
                req.getAccount(),
                req.getOrderQty()
        );
    }

    // 刪除
    public void deleteLike(Integer sn) {
        jdbcTemplate.update("EXEC usp_DeleteLikeItem ?", sn);
    }
}
