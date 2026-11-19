package com._2003store.service;

import com._2003store.dao.OrderDao;
import com._2003store.dao.ProductDao;
import com._2003store.model.Order;
import com._2003store.model.RevenueSummary;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;

public class StatsService {
    private final ProductDao productDao = new ProductDao();
    private final OrderDao orderDao = new OrderDao();
    private final RevenueService revenueService = new RevenueService();

    public int getTotalProducts() {
        return productDao.countProducts();
    }

    public int getTotalStock() {
        return productDao.getTotalStock();
    }

    public int getLowStockCount() {
        return productDao.getLowStockCount(5);
    }

    public int getPendingOrdersCount() {
        return orderDao.getPendingOrdersCount();
    }

    public BigDecimal getAverageOrderValue() {
        int totalPaidOrders = orderDao.getTotalOrders();
        if (totalPaidOrders == 0) {
            return BigDecimal.ZERO;
        }
        return orderDao.getTotalRevenue().divide(BigDecimal.valueOf(totalPaidOrders), 2, java.math.RoundingMode.HALF_UP);
    }

    public BigDecimal getTotalRevenue() {
        return orderDao.getTotalRevenue();
    }

    public int getTotalOrders() {
        return orderDao.getTotalOrders();
    }

    public List<Order> getRecentOrders() {
        return orderDao.getRecentOrders();
    }

    public RevenueSummary getTodayRevenueSummary() {
        return revenueService.getTodaySummary();
    }

    public BigDecimal getTodayRevenue() {
        return getTodayRevenueSummary().getTotalRevenue();
    }

    public BigDecimal getTodayCashRevenue() {
        return getTodayRevenueSummary().getCashRevenue();
    }

    public BigDecimal getTodayTransferRevenue() {
        return getTodayRevenueSummary().getTransferRevenue();
    }

    public int getTodayPaidOrdersCount() {
        return getTodayRevenueSummary().getPaidOrders();
    }

    public BigDecimal getThisMonthRevenue() {
        return orderDao.getRevenueByMonth(YearMonth.now().toString());
    }
}
