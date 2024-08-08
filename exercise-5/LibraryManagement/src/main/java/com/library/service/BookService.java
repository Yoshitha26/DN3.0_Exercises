package com.library.service;

import com.library.repository.BookRepository;

public class BookService {

    private BookRepository bookRepository;

    public void setBookRepository(BookRepository bookRepository)
    {
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
