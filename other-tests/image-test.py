from bs4 import BeautifulSoup
import requests
import os
import re

def extract_url_from_style(style):
    try:
        if style:
            match = re.search(r'url\(["\']?(.*?)["\']?\)', style)
            if match:
                return match.group(1)
    except Exception as e:
        print(f"Error extracting URL from style: {e}")
    return None

def get_image_urls(url):
    try:
        # Send an HTTP GET request to the specified URL
        response = requests.get(url)
        response.raise_for_status()  # Raise an exception for HTTP errors
        html_content = response.text
    except requests.RequestException as e:
        print(f"Error fetching HTML content: {e}")
        return []

    soup = BeautifulSoup(html_content, 'html.parser')
    urls = []

    # Check all elements for background-image
    for element in soup.find_all(style=True):
        background_image = extract_url_from_style(element['style'])
        if background_image:
            urls.append(background_image)

    return urls

def classify_image_urls(image_urls):
    local_images, internet_images = [], []
    for url in image_urls:
        if url.startswith(('http://', 'https://')):
            internet_images.append(url)
        else:
            local_images.append(url)
    return local_images, internet_images

def test_internet_images(internet_images):
    results = {}
    for url in internet_images:
        try:
            response = requests.get(url, timeout=10)
            results[url] = (response.status_code == 200)
        except requests.RequestException as e:
            results[url] = False
            print(f"Error accessing {url}: {e}")
    return results

def test_local_images(local_images, base_path):
    results = {}
    for image in local_images:
        image_path = os.path.join(base_path, image.lstrip('/'))
        results[image] = os.path.exists(image_path)
    return results

if __name__ == "__main__":
    url = 'http://localhost/'  # Update this URL to match the hosted HTML
    print(f"Testing images at URL: {url}")
    image_urls = get_image_urls(url)
    print(f"Found {len(image_urls)} images to test.")
    local_images, internet_images = classify_image_urls(image_urls)
    print(f"{len(internet_images)} internet images and {len(local_images)} local images classified.")

    internet_results = test_internet_images(internet_images)
    for url, is_accessible in internet_results.items():
        print(f"Internet image {url} accessible: {is_accessible}")

    local_results = test_local_images(local_images, url)
    for image, exists in local_results.items():
        print(f"Local image {image} exists: {exists}")