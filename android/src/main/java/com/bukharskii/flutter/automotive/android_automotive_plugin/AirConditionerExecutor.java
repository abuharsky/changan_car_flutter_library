package com.bukharskii.flutter.automotive.android_automotive_plugin;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.ThreadFactory;

public class AirConditionerExecutor {

    /* renamed from: a */
    public static ExecutorService executorServiceInstance;

    /* renamed from: b */
    public static ThreadFactory threadFactory = new AirExecutorThreadFactory();

    /* compiled from: AirConditionerExecutor.java */
    /* renamed from: c.c.a.a.f.c$a */
    /* loaded from: classes.dex */
    public static class AirExecutorThreadFactory implements ThreadFactory {
        @Override // java.util.concurrent.ThreadFactory
        public Thread newThread(Runnable runnable) {
            Thread thread = new Thread(runnable);
            thread.setName("AirExecutor");
            return thread;
        }
    }

    /* renamed from: a */
    public static synchronized ExecutorService executorService() {
        ExecutorService executorService;
        synchronized (AirConditionerExecutor.class) {
            if (executorServiceInstance == null) {
                executorServiceInstance = new ScheduledThreadPoolExecutor(5, threadFactory);
            }
            executorService = executorServiceInstance;
        }
        return executorService;
    }
}
