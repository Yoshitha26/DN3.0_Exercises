package com.library;

import com.library.service.BookService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class MainApp {

    public static void main(String[] args) {
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");

        BookService bookService = (BookService) context.getBean("bookService");

        System.out.println("BookService bean is successfully wired with BookRepository.");

        if (bookService != null && bookService.getBookRepository() != null) {
            System.out.println("BookRepository is successfully injected.");
        } else {
            System.out.println("Dependency injection failed.");
        }
    }
}
