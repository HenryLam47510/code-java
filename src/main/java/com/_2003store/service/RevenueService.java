package com._2003store.service;

import com._2003store.dao.RevenueDao;
import com._2003store.model.RevenueSummary;

import java.time.LocalDate;
import java.time.ZoneId;

public class RevenueService {
    public static final ZoneId VIETNAM_ZONE = ZoneId.of("Asia/Ho_Chi_Minh");
    private final RevenueDao revenueDao = new RevenueDao();

    public LocalDate getVietnamToday() {
        return LocalDate.now(VIETNAM_ZONE);
    }

    public RevenueSummary getTodaySummary() {
        return revenueDao.getDailyRevenue(getVietnamToday());
    }
}
