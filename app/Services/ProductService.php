<?php

namespace App\Services;

class ProductService
{
    public function getProducts()
    {
        return [
            [
                'id' => 1,
                'name' => 'Laptop',
                'price' => 5000000
            ],
            [
                'id' => 2,
                'name' => 'Keyboard',
                'price' => 300000
            ]
        ];
    }
}