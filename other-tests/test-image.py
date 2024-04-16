from bs4 import BeautifulSoup
import requests
import os
import re


def extract_css_from_style_tags(html_content):
    """ Extract CSS from <style> tags. """
    soup = BeautifulSoup(html_content, 'html.parser')
    style_tags = soup.find_all('style')
    css_text = '\n'.join(style_tag.get_text() for style_tag in style_tags)
    return css_text

def find_background_image_in_css(css_text, class_name):
    """ Find background image URL from CSS text for a given class name. """
    pattern = re.compile(r'\.' + re.escape(class_name) + r'\s*\{[^\}]*background-image:\s*url\(["\']?(.+?)["\']?\);?[^\}]*\}', re.DOTALL)
    match = pattern.search(css_text)
    if match:
        return match.group(1)
    return None

def get_image_url_from_webpage(url, class_name):
    """ Get the image URL from a webpage by class name. """
    try:
        response = requests.get(url)
        response.raise_for_status()  # Raise an exception for HTTP errors
        html_content = response.text
        
        # Extract CSS from <style> tags
        css_text = extract_css_from_style_tags(html_content)
        
        # Find background image URL in CSS
        image_url = find_background_image_in_css(css_text, class_name)
        return image_url
    except requests.RequestException as e:
        print(f"Error fetching HTML content: {e}")
        return None

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
    url = 'http://localhost:80/'  # URL to fetch
    print(f"Testing images at URL: {url}")
    class_name = 'banner-image'  # Class name to search for
    
    image_url = get_image_url_from_webpage(url, class_name)
    
    if image_url:
        print(f"Found image URL: {image_url}")
        local_images, internet_images = classify_image_urls([image_url])
        print(f"{len(internet_images)} internet images and {len(local_images)} local images classified.")

        internet_results = test_internet_images(internet_images)
        for url, is_accessible in internet_results.items():
            print(f"Internet image {url} accessible: {is_accessible}")

        local_results = test_local_images(local_images, os.path.dirname(url))
        for image, exists in local_results.items():
            print(f"Local image {image} exists: {exists}")
    else:
        print("No image URL found.")