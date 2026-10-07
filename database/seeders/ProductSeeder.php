<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Product; 
class ProductSeeder extends Seeder
{
    public function run(): void
    {
        Product::create([
            'name' => 'Laptop',
            'price' => 5000000
        ]);
        Product::create([
            'name' => 'Keyboard',
            'price' => 300000
        ]);
    }
}