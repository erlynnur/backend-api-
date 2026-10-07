<?php

namespace App\Http\Controllers;

use App\Services\ProductService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class ProductController extends Controller
{
    protected $productService;

    public function __construct(ProductService $productService)
    {
        $this->productService = $productService;
    }

    public function index()
    {
        $products = $this->productService->getProducts();
        
        return response()->json([
            'success' => true,
            'data' => $products
        ]);
    }

    public function show($id)
    {
        $products = $this->productService->getProducts();
        $product = collect($products)->firstWhere('id', (int)$id);

        if (!$product) {
            return response()->json([
                'success' => false,
                'message' => 'Produk tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $product
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:100',
            'price' => 'required|numeric|min:0'
        ]);

        Log::info('Produk baru aja dibuat', $validated);
        
        return response()->json([
            'success' => true,
            'message' => 'Produk diterima',
            'data' => $validated
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:100',
            'price' => 'sometimes|required|numeric|min:0'
        ]);

        return response()->json([
            'success' => true,
            'message' => "Produk dengan ID {$id} berhasil diubah",
            'data' => $validated
        ], 200);
    }

    public function destroy($id)
    {
        return response()->json([
            'success' => true,
            'message' => "Produk dengan ID {$id} berhasil dihapus"
        ], 200);
    }
}