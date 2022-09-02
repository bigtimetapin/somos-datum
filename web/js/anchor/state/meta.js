export async function getMetaData(url) {
    console.log("fetching meta-data");
    return await fetch(url + "meta.json")
        .then(response => response.json());
}
