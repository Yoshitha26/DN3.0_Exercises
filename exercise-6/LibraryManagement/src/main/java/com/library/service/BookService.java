package com.library.service;

import com.library.repository.BookRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BookService {

    private final BookRepository bookRepository;

    @Autowired
    public BookService(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    public void performService(String bookName) {
        System.out.println("Performing service for book: " + bookName);
        if (bookRepository != null) {
            bookRepository.saveBook(bookName);
        } else {
            System.out.println("BookRepository is not set.");
        }
    }
}
