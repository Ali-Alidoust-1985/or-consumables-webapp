package com.mftplus.eesample.utils;

import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.Interceptor;
import jakarta.interceptor.InvocationContext;
import lombok.extern.slf4j.Slf4j;

import java.util.Arrays;

@Slf4j
@Interceptor
@Loggable
public class LoggerInterceptor {
    @AroundInvoke
    public Object intercept(InvocationContext context) throws Exception {
        try {
            log.info(
                    String.format("%s Started with parameters (%s)",
                            context.getMethod().getName(),
                            Arrays.toString(context.getParameters())
                    )
            );
            Object result = context.proceed();
            log.info(
                    String.format("%s Finished with result (%s)",
                            context.getMethod().getName(),
                            result
                    )
            );
            return result;
        } catch (Exception e) {
            log.error(String.format("%s throws exception (%s)", context.getMethod().getName(), e.getMessage()));
            return e;
        }
    }
}
