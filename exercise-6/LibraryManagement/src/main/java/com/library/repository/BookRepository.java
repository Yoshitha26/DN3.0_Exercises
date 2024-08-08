package com.library.repository;

import org.springframework.stereotype.Repository;

@Repository
public class BookRepository {
    public void saveBook(String bookName) {
        // Simulate saving a book
        System.out.println("Saving book: " + bookName);
    }
}
