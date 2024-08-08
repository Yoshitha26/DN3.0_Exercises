package com.library.service;

import com.library.repository.BookRepository;

public class BookService {

    private BookRepository bookRepository;

    public void setBookRepository(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    public void performService(String bookName) {
        System.out.println("Performing service for book: " + bookName);
        bookRepository.saveBook(bookName);
    }
}
