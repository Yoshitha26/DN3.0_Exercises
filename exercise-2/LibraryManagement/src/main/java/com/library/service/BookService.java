package com.library.service;

import com.library.repository.BookRepository;

public class BookService {

    private BookRepository bookRepository;

    // Setter for BookRepository
    public void setBookRepository(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    // Getter for BookRepository (optional for testing)
    public BookRepository getBookRepository() {
        return bookRepository;
    }

}
